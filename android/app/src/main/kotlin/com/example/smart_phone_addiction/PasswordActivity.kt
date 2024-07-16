//package com.example.smart_phone_addiction
//
//import android.app.ActivityManager
//import android.content.Context
//import android.content.Intent
//import android.os.Bundle
//import android.widget.Button
//import android.widget.EditText
//import android.widget.Toast
//import androidx.appcompat.app.AppCompatActivity
//
//class PasswordActivity : AppCompatActivity() {
//
//    private lateinit var passwordEditText: EditText
//    private lateinit var unlockButton: Button
//    private lateinit var packageName: String
//
//    override
//    fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_password)
//
//        passwordEditText = findViewById(R.id.password_edit_text)
//        unlockButton = findViewById(R.id.unlock_button)
//        packageName = intent.getStringExtra("packageName") ?: ""
//
//        unlockButton.setOnClickListener {
//            val enteredPassword = passwordEditText.text.toString()
//            if (enteredPassword == "1234") { // Replace with your password check
//                finish()
//            } else {
//                Toast.makeText(this, "Incorrect Password", Toast.LENGTH_SHORT).show()
//                killUnauthorizedApp()
//            }
//        }
//    }
//
//    private fun killUnauthorizedApp() {
//        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//        activityManager.killBackgroundProcesses(packageName)
//        Toast.makeText(this, "App $packageName has been blocked", Toast.LENGTH_LONG).show()
//    }
//
//    override fun onBackPressed() {
//        // Prevent back button from closing the password screen
//    }
//}
