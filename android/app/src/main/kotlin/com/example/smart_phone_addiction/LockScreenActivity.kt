package com.example.smart_phone_addiction

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import android.view.WindowManager


class LockScreenActivity : AppCompatActivity() {
    private lateinit var sharedPreferences: SharedPreferences
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        window.setFlags(
//                WindowManager.LayoutParams.FLAG_SECURE or
//                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
//                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
//                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
//                WindowManager.LayoutParams.FLAG_SECURE or
//                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
//                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
//                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
//        )
        // Exclude the activity from recent apps
        intent.flags = intent.flags or Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS
        setContentView(R.layout.lock_screen)
//        val etPassword: EditText = findViewById(R.id.etPassword)
//        val btnSubmit: Button = findViewById(R.id.btnSubmit)
        val btnCancel: Button = findViewById(R.id.btnCancel)
        val packageName = intent.getStringExtra("packageName")
        sharedPreferences = getSharedPreferences(MainActivity.PREFS_NAME, Context.MODE_PRIVATE)

//        btnSubmit.setOnClickListener {
//            val password = etPassword.text.toString()
//            if (isValidPassword(password)) {
//                allowBackPress(true)
//                setAppUnlocked(true)
//                navigateToLockedApp(packageName)
//            } else {
//                Toast.makeText(this, "Incorrect password", Toast.LENGTH_SHORT).show()
//                killUnauthorizedApp(packageName)
//            }
//        }

        btnCancel.setOnClickListener {
            navigateToHome()
        }
    }

    private fun isValidPassword(password: String): Boolean {
        // Implement your password validation logic here
        return password == "1234"
    }
    private fun navigateToHome() {
        val homeIntent = Intent(Intent.ACTION_MAIN)
        homeIntent.addCategory(Intent.CATEGORY_HOME)
        homeIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(homeIntent)
        finish()
    }
    private fun killUnauthorizedApp(packageName: String?) {
        packageName?.let {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            activityManager.killBackgroundProcesses(it)
        }
    }

    @SuppressLint("SuspiciousIndentation")
    private fun allowBackPress(allow: Boolean) {
      val intent = Intent("com.example.smart_phone_addiction.ALLOW_BACK_PRESS")
        intent.putExtra("allow", allow)
        sendBroadcast(intent)
    }
    override fun onBackPressed() {
        super.onBackPressed()
        navigateToHome()
    }
    private fun navigateToLockedApp(packageName: String?) {
        packageName?.let {
            val launchIntent = packageManager.getLaunchIntentForPackage(it)
            if (launchIntent != null) {
                startActivity(launchIntent)
            } else {
                Toast.makeText(this, "Unable to open the app", Toast.LENGTH_SHORT).show()
                navigateToHome()
            }
        }
        finish()
    }
    private fun setAppUnlocked(unlocked: Boolean) {
        sharedPreferences.edit().putBoolean(MainActivity.UNLOCKED_KEY, unlocked).apply()
    }

    override fun onDestroy() {
        super.onDestroy()
        //AppLockService.isLockScreenVisible = false
    }
}
