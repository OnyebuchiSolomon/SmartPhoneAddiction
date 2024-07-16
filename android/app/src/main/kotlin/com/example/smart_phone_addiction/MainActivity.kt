package com.example.smart_phone_addiction
import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.activity.OnBackPressedDispatcher
import androidx.activity.OnBackPressedDispatcherOwner
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.app_locker/accessibility"
        private const val REQUEST_OVERLAY_PERMISSION = 1001
        const val PREFS_NAME = "AppLockPrefs"
        const val UNLOCKED_KEY = "isUnlocked"
    }
    private var shouldAllowBack = false
    private lateinit var sharedPreferences: SharedPreferences
    private val lockScreenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.example.smart_phone_addiction.LOCK_SCREEN") {
                val packageName = intent.getStringExtra("packageName")
                if (packageName != null) {
                    showLockScreen(packageName)
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerReceiver(lockScreenReceiver, IntentFilter("com.example.smart_phone_addiction.LOCK_SCREEN"), RECEIVER_VISIBLE_TO_INSTANT_APPS)
        sharedPreferences = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                    when (call.method) {

                        "openAccessibilitySettings" -> {
                            openAccessibilitySettings()
                            result.success(null)
                        }

                        "checkOverlayPermission" -> {
                            requestOverlayPermission()

                        }


                        "setBlockedApps" -> {
                            val blockedApps = call.argument<List<String>>("blockedApps")
                            if (blockedApps != null) {
                                saveBlockedApps(blockedApps)
                                result.success(null)
                            } else {
                                result.error("INVALID_ARGUMENT", "Blocked apps list is null", null)
                            }


                        }

                   }
                }
//        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
//            override fun handleOnBackPressed() {
//                if (shouldAllowBack) {
//                    Toast.makeText(this@MainActivity, "password to go back", Toast.LENGTH_SHORT).show()
//                    finish()
//                } else {
//                    Toast.makeText(this@MainActivity, "You need to enter password to go back", Toast.LENGTH_SHORT).show()
//                }
//            }
//        })
    }
    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }
    private fun saveBlockedApps(blockedApps: List<String>) {
        val editor = sharedPreferences.edit()
        editor.putStringSet("blockedApps", blockedApps.toSet())
        editor.apply()
        Toast.makeText(this, "blockedApps"+blockedApps+"Main Activity", Toast.LENGTH_SHORT).show()

    }
    private fun showLockScreen(packageName: String) {
        // Start LockScreenActivity
        val intent = Intent(this, LockScreenActivity::class.java)
        intent.putExtra("packageName", packageName)
        startActivity(intent)
    }

override fun onDestroy() {
        super.onDestroy()
        // Unregister the BroadcastReceiver
        unregisterReceiver(lockScreenReceiver)
    }


    private fun requestOverlayPermission() {
        val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
        )
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivityForResult(intent, REQUEST_OVERLAY_PERMISSION)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_OVERLAY_PERMISSION) {
            if (Settings.canDrawOverlays(this)) {
                Toast.makeText(this, "Overlay permission is granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "Overlay permission is required", Toast.LENGTH_SHORT).show()
            }
        }
    }
    private fun isAccessGranted(): Boolean {
        return try {
            val packageManager = packageManager
            val applicationInfo = packageManager.getApplicationInfo(
                    packageName, 0
            )
            val appOpsManager: AppOpsManager = getSystemService(APP_OPS_SERVICE) as AppOpsManager
            val mode = appOpsManager.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    applicationInfo.uid, applicationInfo.packageName
            )
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
    private fun setAppUnlocked(unlocked: Boolean) {
        sharedPreferences.edit().putBoolean(UNLOCKED_KEY, unlocked).apply()
    }

    override fun onStop() {
        super.onStop()
        // Reset unlock status when the app is minimized or closed
        setAppUnlocked(false)
        AppLockService.isLockScreenVisible = false
    }
    }



