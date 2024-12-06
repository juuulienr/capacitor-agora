package com.example.agoraplugin;

import android.Manifest;
import android.content.Context;
import android.view.ViewGroup;

import com.getcapacitor.Plugin;
import com.getcapacitor.Bridge;
import com.getcapacitor.PluginCall;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;

@CapacitorPlugin(
  name = "AgoraPlugin",
  permissions = {
    @Permission(alias = "camera", strings = {Manifest.permission.CAMERA}),
    @Permission(alias = "microphone", strings = {Manifest.permission.RECORD_AUDIO})
  }
)
public class AgoraPlugin extends Plugin {
  private final Agora implementation = new Agora();

  @PluginMethod
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

  @PluginMethod
  public void requestPermissions(PluginCall call) {
    if (!implementation.requestPermissions(getContext())) {
      requestAllPermissions(call, "handlePermissionsCallback");
    } else {
      call.resolve();
    }
  }

  @PermissionCallback
  private void handlePermissionsCallback(PluginCall call) {
    if (PermissionUtils.hasAllPermissions(getContext())) {
      call.resolve();
    } else {
      implementation.openAppSettings(getContext());
      call.reject("Permissions not granted. Redirected to app settings.");
    }
  }

  @PluginMethod
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

  @PluginMethod
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

  @PluginMethod
  public void switchCamera(PluginCall call) {
    try {
      implementation.switchCamera();
      call.resolve();
    } catch (Exception e) {
      call.reject("Failed to switch camera", e);
    }
  }

  @PluginMethod
  public void leaveChannel(PluginCall call) {
    Bridge bridge = getBridge();
    ViewGroup parentView = (ViewGroup) bridge.getActivity().findViewById(android.R.id.content);

    implementation.leaveChannel(parentView);
    call.resolve();
  }
}
