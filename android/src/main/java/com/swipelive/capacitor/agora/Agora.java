package com.swipelive.capacitor.agora;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;
import android.util.Log;
import android.view.SurfaceView;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import android.content.pm.PackageManager;

import io.agora.rtc2.*;
import io.agora.rtc2.video.VideoCanvas;
import io.agora.rtc2.video.VideoEncoderConfiguration;

public class Agora {
  private static final String TAG = "Agora";
  private RtcEngine agoraEngine;
  private FrameLayout localVideoContainer;

  public void initialize(Context context, String appId) throws Exception {
    if (appId == null || appId.isEmpty()) {
      throw new IllegalArgumentException("App ID is required");
    }
    agoraEngine = RtcEngine.create(context, appId, new IRtcEngineEventHandler() {
      @Override
      public void onError(int err) {
        Log.e(TAG, "Agora SDK Error: " + err);
      }

      @Override
      public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        Log.i(TAG, "Joined channel " + channel + " with UID " + uid);
      }

      @Override
      public void onLeaveChannel(RtcStats stats) {
        Log.i(TAG, "Left channel after " + stats.totalDuration + " seconds");
      }
    });

    VideoEncoderConfiguration config = new VideoEncoderConfiguration(
      VideoEncoderConfiguration.VD_1920x1080,
      VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_30,
      VideoEncoderConfiguration.STANDARD_BITRATE,
      VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT
    );

    agoraEngine.setVideoEncoderConfiguration(config);
    agoraEngine.enableVideo();
    Log.i(TAG, "Agora video enabled and initialized");
  }

  public boolean hasAllPermissions(Context context) {
    return context.checkSelfPermission(android.Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED &&
           context.checkSelfPermission(android.Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED;
  }

  public boolean requestPermissions(Context context) {
    if (hasAllPermissions(context)) {
      Log.i(TAG, "All permissions are already granted");
      return true;
    }

    Log.i(TAG, "Requesting camera and microphone permissions");
    ActivityCompat.requestPermissions(
      (android.app.Activity) context,
      new String[]{
        android.Manifest.permission.CAMERA,
        android.Manifest.permission.RECORD_AUDIO
      },
      1 // Request code arbitraire pour identifier la demande
    );
    return false;
  }

  public void openAppSettings(Context context) {
    Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
    intent.setData(Uri.parse("package:" + context.getPackageName()));
    context.startActivity(intent);
  }

  public void setupLocalVideo(@NonNull Context context, @NonNull ViewGroup parentView) throws Exception {
    if (agoraEngine == null) {
      throw new IllegalStateException("Agora engine not initialized");
    }

    SurfaceView localVideoView = new SurfaceView(context);
    localVideoContainer = new FrameLayout(context);
    localVideoContainer.addView(localVideoView, new FrameLayout.LayoutParams(
      FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
    parentView.addView(localVideoContainer);

    VideoCanvas videoCanvas = new VideoCanvas(localVideoView, VideoCanvas.RENDER_MODE_HIDDEN, 0);
    agoraEngine.setupLocalVideo(videoCanvas);
    agoraEngine.startPreview();

    Log.i(TAG, "Local video view initialized and preview started");
  }

  public void joinChannel(String channelName, String token, int uid) throws Exception {
    if (agoraEngine == null) {
      throw new IllegalStateException("Agora engine not initialized");
    }

    agoraEngine.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
    agoraEngine.joinChannel(token, channelName, "", uid);
    Log.i(TAG, "Joining channel: " + channelName);
  }

  public void switchCamera() throws Exception {
    if (agoraEngine == null) {
      throw new IllegalStateException("Agora engine not initialized");
    }
    agoraEngine.switchCamera();
  }

  public void leaveChannel(ViewGroup parentView) {
    if (agoraEngine == null) {
      Log.e(TAG, "Cannot leave channel, Agora engine not initialized");
      return;
    }

    agoraEngine.stopPreview();
    agoraEngine.leaveChannel();
    Log.i(TAG, "Left channel");

    if (localVideoContainer != null) {
      parentView.removeView(localVideoContainer);
      localVideoContainer = null;
    }
  }
}
