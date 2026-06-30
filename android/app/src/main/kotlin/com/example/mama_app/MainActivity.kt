package com.app.wemama

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "onCreate — intent action: ${intent?.action}")
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("MainActivity", "onNewIntent — action: ${intent.action}")
        super.onNewIntent(intent)
    }
}
