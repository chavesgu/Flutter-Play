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
    String data = getHWMsg(intent);
    if (data!=null) PushPlugin.HWLaunchMsg.put("msg", data);
  }

  @Override
  protected void onNewIntent(Intent intent) {
    if (PushPlugin.HWLaunchMsg.containsKey("msg")) return;
    String data = getHWMsg(intent);
    if (data!=null) {
      final Map<String, String> msg = new HashMap<>();
      msg.put("msg", data);
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

  private String getHWMsg(Intent intent) {
    if (null != intent && intent.getData() != null) {
      Uri intentData = intent.getData();
      if (intentData.getScheme().equals("msg")) {
        return intentData.getQueryParameter("data");
      }
      return null;
    }
    return null;
  }
}