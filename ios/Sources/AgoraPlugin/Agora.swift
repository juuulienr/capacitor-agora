import Foundation
import AgoraRtcKit
import UIKit

@objc public class Agora: NSObject {
  private var rtcEngine: AgoraRtcEngineKit?
  private var videoView: UIView?
  private var originalBackgroundColor: UIColor?

  @objc public func initialize(appId: String) -> String {
    if appId.isEmpty {
      return "Invalid App ID"
    }

    rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    if rtcEngine != nil {
      print("rtcEngine initialized")
      return "Agora initialized successfully"
    } else {
      print("rtcEngine initialization failed")
      return "Agora initialization failed"
    }
  }

  @objc public func createMicrophoneAndCameraTracks(options: [String: Any]) -> String {
    guard let rtcEngine = rtcEngine else {
      return "Agora not initialized"
    }

    let frameRate = options["frameRate"] as? Int ?? AgoraVideoFrameRate.fps30.rawValue
    let bitrate = options["bitrate"] as? Int ?? AgoraVideoBitrateStandard
    let orientationMode = AgoraVideoOutputOrientationMode(rawValue: options["orientationMode"] as? Int ?? AgoraVideoOutputOrientationMode.adaptative.rawValue) ?? .adaptative
    let mirrorMode = AgoraVideoMirrorMode(rawValue: options["mirrorMode"] as? Int ?? AgoraVideoMirrorMode.auto.rawValue) ?? .auto

    let config = AgoraVideoEncoderConfiguration(
      size: AgoraVideoDimension1920x1080,
      frameRate: AgoraVideoFrameRate(rawValue: frameRate) ?? .fps30,
      bitrate: bitrate,
      orientationMode: orientationMode,
      mirrorMode: mirrorMode
    )

    rtcEngine.setVideoEncoderConfiguration(config)
    rtcEngine.enableVideo()
    rtcEngine.startPreview()

    return "Microphone and camera tracks created successfully"
  }

  @objc public func setupLocalVideo(options: [String: Any], webView: UIView) -> String {
    guard let rtcEngine = rtcEngine else {
      return "Agora not initialized"
    }

    guard let uid = options["uid"] as? Int,
          let left = options["left"] as? CGFloat,
          let top = options["top"] as? CGFloat,
          let width = options["width"] as? CGFloat,
          let height = options["height"] as? CGFloat else {
      return "Invalid arguments"
    }

    // Logs pour le débogage
    print("setupLocalVideo called with uid: \(uid), left: \(left), top: \(top), width: \(width), height: \(height)")

    // Configuration de la vue vidéo
    let videoFrame = CGRect(x: left, y: top, width: width, height: height)
    videoView = UIView(frame: videoFrame)
    videoView?.backgroundColor = .clear

    // Ajoute la vue vidéo derrière la WebView
    originalBackgroundColor = webView.backgroundColor
    webView.backgroundColor = .clear
    webView.superview?.insertSubview(videoView!, belowSubview: webView)

    // Configuration d'Agora
    let videoCanvas = AgoraRtcVideoCanvas()
    videoCanvas.uid = UInt(uid)
    videoCanvas.view = videoView
    videoCanvas.renderMode = .hidden
    videoCanvas.mirrorMode = .auto

    rtcEngine.setupLocalVideo(videoCanvas)

    print("Local video setup completed for uid: \(uid)")
    return "Local video setup completed"
  }


  @objc public func startPreview() -> String {
    guard let rtcEngine = rtcEngine else {
      return "Agora not initialized"
    }
    rtcEngine.startPreview()
    return "Preview started"
  }

}
