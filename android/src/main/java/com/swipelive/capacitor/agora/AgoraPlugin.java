package com.swipelive.capacitor.agora;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.view.ViewGroup;

import androidx.core.app.ActivityCompat;

import com.getcapacitor.Plugin;
import com.getcapacitor.Bridge;
import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;


@CapacitorPlugin(
  name = "Agora",
  permissions = {
    @Permission(alias = "camera", strings = {Manifest.permission.CAMERA}),
    @Permission(alias = "microphone", strings = {Manifest.permission.RECORD_AUDIO})
  }
)
public class AgoraPlugin extends Plugin {
  private final Agora implementation = new Agora();

  public void initialize(PluginCall call) {
    String appId = call.getString("appId");
    if (appId == null || appId.isEmpty()) {
      call.reject("Missing App ID");
      return;
    }
    try {
      implementation.initialize(getContext(), appId);
      call.resolve();
    } catch (Exception e) {
      call.reject("Failed to initialize Agora SDK", e);
    }
  }

  public void requestPermissions(PluginCall call) {
    if (implementation.requestPermissions(getContext())) {
        call.resolve();
    } else {
        call.reject("Permissions required");
    }
  }

  public void setupLocalVideo(PluginCall call) {
    try {
      Bridge bridge = getBridge();
      Context context = getContext();
      ViewGroup parentView = (ViewGroup) bridge.getActivity().findViewById(android.R.id.content);

      implementation.setupLocalVideo(context, parentView);
      call.resolve();
    } catch (Exception e) {
      call.reject("Failed to setup local video", e);
    }
  }

  public void joinChannel(PluginCall call) {
    String channelName = call.getString("channelName");
    String token = call.getString("token");
    int uid = call.getInt("uid", 0);

    if (channelName == null || channelName.isEmpty()) {
      call.reject("Missing channel name");
      return;
    }

    try {
      implementation.joinChannel(channelName, token, uid);
      call.resolve();
    } catch (Exception e) {
      call.reject("Failed to join channel", e);
    }
  }

  public void switchCamera(PluginCall call) {
    try {
      implementation.switchCamera();
      call.resolve();
    } catch (Exception e) {
      call.reject("Failed to switch camera", e);
    }
  }

  public void leaveChannel(PluginCall call) {
    Bridge bridge = getBridge();
    ViewGroup parentView = (ViewGroup) bridge.getActivity().findViewById(android.R.id.content);

    implementation.leaveChannel(parentView);
    call.resolve();
  }
}
