package com.example.smart_phone_addiction;
import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;
import androidx.annotation.RequiresApi;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;


public class AppLockService extends AccessibilityService {
    private static SharedPreferences sharedPreferences;
   public static  boolean isLockScreenVisible = false;

    private static final String TAG = "AppLockService";
    private static final String CORRECT_PASSWORD = "1234";
    private final List<String> whiteList = new ArrayList<>();
   // private Set<String> whiteList;
    private WindowManager windowManager;
    private View lockView;
     boolean lockScreenShown = false;

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        sharedPreferences = getSharedPreferences(MainActivity.PREFS_NAME, Context.MODE_PRIVATE);
        String packageName = event.getPackageName() != null ? event.getPackageName().toString() : null;
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            String currentPackageName = event.getPackageName().toString();
            Log.d(TAG, "Current package: " + packageName);
           // Toast.makeText(this, "App "+packageName+" has been taped", Toast.LENGTH_LONG).show();
           // sharedPreferences = getSharedPreferences("AppLockPrefs", Context.MODE_PRIVATE);
                if (isAppInstalled(currentPackageName) && isAppBlocked(currentPackageName) && !isLockScreenVisible) {
                    Log.d(TAG, "Blocking package: " + packageName);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                            // if (packageName != null && isUnauthorizedApp(packageName) && !isLockScreenVisible) {
                            sendLockScreenBroadcast(packageName);

                       // Toast.makeText(this, "App " + packageName + " is blocked.", Toast.LENGTH_SHORT).show();
                    }
            }
        }
    }
    private boolean isAppBlocked(String packageName) {

      //  Toast.makeText(this, "blockedApps"+blockedApps+"Main Activity", Toast.LENGTH_SHORT).show()

        return sharedPreferences.getStringSet("blockedApps", new HashSet<>()).contains(packageName);
    }
    private boolean isAppInstalled(String packageName) {
        PackageManager packageManager = getPackageManager();
        try {
            packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES);
           // Toast.makeText(this, "App " + packageName + " system app.", Toast.LENGTH_SHORT).show();
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();

        AccessibilityServiceInfo info = new AccessibilityServiceInfo();
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        info.notificationTimeout = 100;
        setServiceInfo(info);

        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);

        loadWhitelist();

    }


    @Override
    public void onInterrupt() {
    }

//    @SuppressLint("InflateParams")
//    @RequiresApi(api = Build.VERSION_CODES.O)
//    private void lockApp() {
//        if (lockView == null) {
//            LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//            lockView = inflater.inflate(R.layout.lock_screen, null);
//
//            WindowManager.LayoutParams params = new WindowManager.LayoutParams(
//                    WindowManager.LayoutParams.MATCH_PARENT,
//                    WindowManager.LayoutParams.MATCH_PARENT,
//                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
//                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
//                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//
//            );
//            params.gravity = Gravity.CENTER;
//            windowManager.addView(lockView, params);
//        }
//    }
@SuppressLint("InflateParams")
@RequiresApi(api = Build.VERSION_CODES.O)
private void lockApp() {
//    if (lockView == null) {
//        LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//        lockView = inflater.inflate(R.layout.lock_screen, null);
//
//        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
//                WindowManager.LayoutParams.MATCH_PARENT,
//                WindowManager.LayoutParams.MATCH_PARENT,
//                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
//                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
//                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//        );
//        params.gravity = Gravity.CENTER;
//        windowManager.addView(lockView, params);
//
//        lockView.findViewById(R.id.btn_cancel).setOnClickListener(v -> navigateHome());
//        lockView.findViewById(R.id.btn_unlock).setOnClickListener(v -> unlockApp());
//        EditText passwordField = lockView.findViewById(R.id.edit_text_password);
//        passwordField.requestFocus();
//        passwordField.postDelayed(() -> {
//            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
//            if (imm != null) {
//                imm.showSoftInput(passwordField, InputMethodManager.SHOW_FORCED);
//            }
//        }, 100);
//        lockView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
//                | View.SYSTEM_UI_FLAG_FULLSCREEN
//                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
//        lockView.setFocusableInTouchMode(true);
//        lockView.requestFocus();
//        lockView.setOnKeyListener((v, keyCode, event) -> {
//            if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_UP) {
//                Toast.makeText(this, "Incorrect password", Toast.LENGTH_SHORT).show();
//                navigateHome();
//                return true;
//            }
//            return false;
//        });
//
//        lockView.setOnApplyWindowInsetsListener((v, insets) -> {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                return WindowInsets.CONSUMED;
//            } else {
//                return insets.consumeSystemWindowInsets();
//            }
//        });
//    }
}



    private void removeView() {
        if (lockView != null) {
            windowManager.removeView(lockView);
            lockView = null;
        }
    }
    private void navigateHome() {
        Intent startMain = new Intent(Intent.ACTION_MAIN);
        startMain.addCategory(Intent.CATEGORY_HOME);
        startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(startMain);
        removeView();
    }
    private void loadWhitelist() {

        whiteList.clear();
        whiteList.add("com.whatsapp");

    }

    private void sendLockScreenBroadcast(String packageName) {

            Intent intent = new Intent("com.example.smart_phone_addiction.LOCK_SCREEN");
            intent.putExtra("packageName", packageName);
            sendBroadcast(intent);

    }
}
