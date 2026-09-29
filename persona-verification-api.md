# Identity Verification (Persona) — Frontend Integration Guide

This document covers the two API endpoints the app calls to run a user through
Persona identity verification, plus what to do with the `sessionToken` Persona
gives back.

> **Scope:** Identity verification is only available to regular **User**
> accounts. Expert accounts cannot call these endpoints (see Errors below).

---

## 1. Overview / Flow

```
┌─────────┐                      ┌──────────┐                    ┌─────────┐
│  App    │  1. POST /session    │ Backend  │  creates/resumes    │ Persona │
│         │ ───────────────────► │          │ ───────────────────►│         │
│         │  ◄─────────────────  │          │ ◄─────────────────  │         │
│         │  { inquiryId,        │          │  sessionToken        │         │
│         │    sessionToken }    │          │                      │         │
└────┬────┘                      └──────────┘                    └─────────┘
     │
     │ 2. Open Persona WebView / SDK with sessionToken
     │    User completes ID capture + selfie inside Persona's UI
     ▼
┌─────────┐
│  App    │  3. Persona WebView closes (user done, back in app)
└────┬────┘
     │
     │ 4. GET /status  — poll every ~3s
     ▼
┌──────────┐        ┌─────────┐
│ Backend  │◄───────┤ Persona │  (Persona calls our webhook in the
│          │webhook │         │   background — not something the
└──────────┘        └─────────┘   frontend talks to directly)
     │
     ▼
  status becomes final (approved / declined / needs_review / expired)
  → stop polling, show result to user
```

The backend never talks to Persona synchronously for status updates — Persona
sends a webhook to the backend when the inquiry's status changes, and the app
polls `GET /status` until it sees a final status.

---

## 2. Auth

Every endpoint below requires a normal logged-in **User** access token:

```
Authorization: Bearer <accessToken>
```

Same token you already use for every other authenticated endpoint in the app.

---

## 3. `POST /verification/session`

Call this when the user taps **"Verify Identity"**, or when the app reopens
and there's a verification still in progress (safe to call again — it will
resume the existing inquiry instead of creating a duplicate one).

**Request**

```
POST /verification/session
Authorization: Bearer <accessToken>
```

No request body needed.

**Success response — `200 OK`**

```json
{
  "success": true,
  "message": "Verification session created successfully.",
  "data": {
    "inquiryId": "inq_abc123",
    "sessionToken": "s_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `inquiryId` | string | Save this — useful for support/debugging, not required to open the SDK |
| `sessionToken` | string | Pass directly into the Persona SDK/WebView. **Expires in ~10 minutes** — do not cache it, request a fresh one each time the user starts/resumes verification |

**What to do with `sessionToken`:**
Open Persona's hosted flow (WebView) or native SDK (iOS/Android/React Native/Flutter — whichever Persona SDK the app uses) passing `sessionToken` so it resumes the correct inquiry. Refer to Persona's own SDK docs for the exact API — this backend only issues the token, it doesn't render any UI.

**Error responses**

| Status | Body `message` | Meaning / what to show the user |
|---|---|---|
| `401` | `You are not authorized to perform this action.` / `Access token expired` | User isn't logged in / token expired → send to login |
| `403` | `Identity verification is only available for user accounts.` | Should never happen for a normal user account — hide the "Verify Identity" entry point for non-User accounts |
| `409` | `Your identity is already verified.` | User is already verified — don't show "Verify Identity" at all if you already know `isIdVerified` is true |
| `429` | `Too many verification attempts. Please try again in 15 minutes.` | Rate-limited (max 20 attempts / user / 15 min) — show a "try again later" message |
| `502` | `Persona: <detail>` | Persona's API had an issue — show a generic "verification service unavailable, try again" and let the user retry |

All error bodies follow this shape (except 429, see below):

```json
{
  "success": false,
  "message": "Your identity is already verified.",
  "errorDetails": {},
  "stack": null
}
```

The `429` rate-limit response has a slightly different (flatter) shape:

```json
{
  "success": false,
  "message": "Too many verification attempts. Please try again in 15 minutes."
}
```

In both cases, **`message` is the string safe to show the user** (or map to your own localized copy).

---

## 4. `GET /verification/status`

Poll this after the Persona WebView/SDK closes, every **~3 seconds**, until
`status` becomes one of the **final** values below. Stop polling once you hit
a final status.

**Request**

```
GET /verification/status
Authorization: Bearer <accessToken>
```

**Success response — `200 OK`**

```json
{
  "success": true,
  "message": "Verification status fetched successfully.",
  "data": {
    "status": "processing",
    "completedAt": null
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `status` | string enum (see table below) | Current verification state |
| `completedAt` | string (ISO date) \| `null` | Set once the inquiry reaches a final state |

### Status values

| `status` | Final? | Meaning | What to show / do |
|---|---|---|---|
| `not_started` | — | User has never started a verification | Show "Verify Identity" CTA |
| `pending` | No | Inquiry created, user hasn't finished the Persona flow yet (or app hasn't opened it) | Keep polling, or prompt user to resume |
| `processing` | No | User finished the Persona flow, Persona is reviewing | Keep polling (show a spinner / "reviewing your ID") |
| `approved` | **Yes** | Verified ✅ | Show success, unlock whatever feature required verification |
| `declined` | **Yes** | Persona rejected the submission | Show failure, offer to retry (calls `POST /session` again) |
| `needs_review` | **Yes**\* | Flagged for manual review by Persona's team | Show "under review" — this can still change later; you may want to keep light polling (e.g. every 30–60s) rather than stopping entirely |
| `expired` | **Yes** | Session/inquiry expired before completion | Show failure, offer to retry |

\* `needs_review` is "final" in the sense that Persona's automated check is done, but a human reviewer can still move it to `approved`/`declined` later. Treat it as a stopping point for fast polling, but it's reasonable to re-check status when the user reopens the verification screen.

**Error responses:** same `401` cases as above (expired/invalid/missing token). There's no 403/404 here — if nothing was ever started, you just get `status: "not_started"`, not an error.

---

## 5. Practical integration notes

- **Don't poll forever.** Cap it (e.g. stop after 2 minutes of polling and tell the user to check back later) — `needs_review` can take Persona's team a while.
- **`sessionToken` is short-lived (~10 min).** If the user backgrounds the app mid-flow and comes back later, call `POST /session` again before reopening the Persona UI — it will transparently resume the same `inquiryId` with a fresh token rather than starting over.
- **Gate the "Verify Identity" entry point** using whatever user/profile data you already have cached (e.g. an `isIdVerified` flag) to avoid unnecessary `409`s — but still handle the `409` gracefully since it's authoritative.
- **Redirect URI:** the backend is configured with `wemama://verification` as Persona's redirect URI. If you're using a WebView-based hosted flow rather than a native SDK, this is the deep link Persona will redirect to when the flow closes — make sure the app has that URL scheme registered and handles it (simplest handling: just close the WebView, then call `GET /status`).
- **No request bodies** are needed for either endpoint — everything is derived from the bearer token.

---

## 6. Quick reference

| Endpoint | Method | Auth | Body | Rate limit |
|---|---|---|---|---|
| `/verification/session` | POST | Required (User) | none | 20 / 15 min per user |
| `/verification/status` | GET | Required (User) | none | none |
