enum BrdrSideType { bottom, top, right, left }

enum SupplierTabType { requested, accepted, readyToDelivery, delivered, rejected, confirmed }

enum UserRole { customer, supplier, admin }

enum OtpFlowType { signup, forgotPassword }

enum FuelType { fuel, diesel }

enum CreateOrderState { loading, success, failure }

enum NotificationType { sentMessage, sentwave, acceptWave, approveCommunity, none }

// SENT_MESSAGE
// SENT_WAVE
// ACCEPT_WAVE
// APPROVE_COMMUNITY
// SENT_MESSAGE
enum SupplierOrderAction { accept, onTheWay, complete, delete, confirm, reject, cancel }

enum SessionStatus { upcoming, ongoing }
