import AVFoundation
import AgoraRtcKit
import UIKit

@objc public class Agora: NSObject, AgoraRtcEngineDelegate {
  private var agoraKit: AgoraRtcEngineKit?
  private var localVideoView: UIView?

  public func initialize(appId: String) throws {
    let agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
    self.agoraKit = agoraKit

    let videoConfig = AgoraVideoEncoderConfiguration(
      size: AgoraVideoDimension1920x1080,
      frameRate: .fps30,
      bitrate: AgoraVideoBitrateStandard,
      orientationMode: .fixedPortrait,
      mirrorMode: .disabled
    )
    
    agoraKit.setVideoEncoderConfiguration(videoConfig)
    agoraKit.setLogFilter(AgoraLogFilter.debug.rawValue)

    DispatchQueue.global(qos: .userInitiated).async {
      agoraKit.enableVideo()
      print("[Agora] Video enabled during initialization")
    }
  }

  public func requestPermissionsSync() -> Bool {
    return self.requestCameraAndMicrophoneAccessSync()
  }

  private func requestCameraAndMicrophoneAccessSync() -> Bool {
    let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    let microphoneStatus = AVAudioSession.sharedInstance().recordPermission

    if cameraStatus == .authorized && microphoneStatus == .granted {
      return true
    }

    let semaphore = DispatchSemaphore(value: 0)
    var accessGranted = false

    AVCaptureDevice.requestAccess(for: .video) { cameraGranted in
      if cameraGranted {
        AVAudioSession.sharedInstance().requestRecordPermission { microphoneGranted in
          accessGranted = microphoneGranted
          semaphore.signal()
        }
      } else {
        semaphore.signal()
      }
    }

    semaphore.wait()
    return accessGranted
  }

  public func openAppSettings() {
    if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
      DispatchQueue.main.async {
        if UIApplication.shared.canOpenURL(appSettingsURL) {
          UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
          print("[Agora] Redirecting to app settings")
        }
      }
    }
  }

  public func setupLocalVideo(in parentView: UIView) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(
        domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    DispatchQueue.main.async {
      self.localVideoView = UIView(frame: parentView.bounds)
      parentView.insertSubview(self.localVideoView!, at: 0)
      parentView.isOpaque = false
      parentView.backgroundColor = .clear
      parentView.scrollView.backgroundColor = .clear
      print("[Agora] Inserted localVideoView behind ParentView content")

      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.view = self.localVideoView
      videoCanvas.uid = 0
      agoraKit.setupLocalVideo(videoCanvas)
      print("[Agora] Configured Agora video canvas")

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        agoraKit.startPreview()
        print("[Agora] Video preview started")
      }
    }
  }

  public func joinChannel(channelName: String, token: String?, uid: UInt) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(
        domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    agoraKit.setClientRole(.broadcaster)
    agoraKit.setChannelProfile(.liveBroadcasting)
    agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) { channel, uid, elapsed in
      print("[Agora] Joined channel \(channel) with UID \(uid), elapsed \(elapsed) ms")
    }
  }

  public func switchCamera() throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(
        domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }
    agoraKit.switchCamera()
  }

  public func leaveChannel(for parentView: UIView) {
    guard let agoraKit = self.agoraKit else {
      print("[Agora] Cannot leave channel, Agora not initialized")
      return
    }

    agoraKit.stopPreview()
    agoraKit.enableLocalVideo(false)
    print("[Agora] Camera preview stopped and local video disabled")

    agoraKit.muteLocalAudioStream(true)
    print("[Agora] Local audio muted")

    agoraKit.leaveChannel(nil)
    print("[Agora] Left channel")

    DispatchQueue.main.async {
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = nil
      parentView.isOpaque = true
      parentView.backgroundColor = .white
      parentView.scrollView.backgroundColor = .clear
      print("[Agora] WebView transparency disabled in leaveChannel")
    }
  }

  // Capture des logs et événements Agora dans la console
  public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
    print("[Agora] Error occurred: \(errorCode.rawValue)")
  }

  public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
    print("[Agora] Joined channel \(channel) with UID \(uid), elapsed \(elapsed) ms")
  }

  public func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
    print("[Agora] Left channel. Duration: \(stats.duration) seconds")
  }

  public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
    print("[Agora] Warning occurred: \(warningCode.rawValue)")
  }

  public func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
    print("[Agora] RTC stats: Duration \(stats.duration) seconds, Users \(stats.userCount), TX \(stats.txBytes) bytes, RX \(stats.rxBytes) bytes")
  }
}
