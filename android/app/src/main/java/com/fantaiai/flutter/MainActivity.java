package com.fantaiai.flutter;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.chavesgu.push.PushPlugin;
//import com.tencent.bugly.crashreport.CrashReport;

import org.json.JSONObject;
import org.json.JSONStringer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

//import io.flutter.app.FlutterActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    super.configureFlutterEngine(flutterEngine);
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
//    GeneratedPluginRegistrant.registerWith(this);

//    CrashReport.initCrashReport(getApplicationContext(), "22481154f7", true);

    Intent intent = getIntent();
    String data = getPushMsg(intent);
    if (data!=null) PushPlugin.launchMsg.put("msg", data);
  }

  @Override
  protected void onNewIntent(Intent intent) {
    if (PushPlugin.launchMsg.containsKey("msg")) return;
    String data = getPushMsg(intent);
    if (data!=null) {
      final Map<String, String> msg = new HashMap<>();
      msg.put("msg", data);
      if (PushPlugin.appOnForeground()){ // app在前台
//        PushPlugin._channel.invokeMethod("onMessage", msg);
      } else { // app在后台
        PushPlugin.moveTaskToFront();
//        PushPlugin._channel.invokeMethod("onResume", msg);
      }
      PushPlugin._channel.invokeMethod("onMessage", msg);
    };
  }

  @Override
  protected void onResume() {
    super.onResume();
  }

  @Override
  protected void onPause() {
    super.onPause();
  }

  private String getPushMsg(Intent intent) {
    if (null != intent) {
      // 获取data
      Bundle bundle = intent.getExtras();
      if (bundle != null) {
        String data = null;
        for (String key : bundle.keySet()) {
          Log.i("push", "key is " + key);
          if (key.equals("msg")) {
            Object content = bundle.get(key);
            data = content.toString();
          }
        }
        if (data!=null) return data;
        return null;
      }
      return null;
    } else {
      Log.i("push", "intent is null");
      return null;
    }
  }
}