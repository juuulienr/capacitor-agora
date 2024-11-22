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

    print("rtcEngine initialized")
    return "Agora initialized successfully"
  }

  @objc public func createMicrophoneAndCameraTracks(options: [String: Any]) -> String {
    guard let rtcEngine = rtcEngine else {
      return "Agora not initialized"
    }

    let frameRate = options["frameRate"] as? Int ?? AgoraVideoFrameRate.fps30.rawValue
    let bitrate = options["bitrate"] as? Int ?? AgoraVideoBitrateStandard
    let orientationMode = AgoraVideoOutputOrientationMode(rawValue: options["orientationMode"] as? Int ?? AgoraVideoOutputOrientationMode.adaptative.rawValue) ?? .adaptative
    let mirrorMode = AgoraVideoMirrorMode(rawValue: UInt(options["mirrorMode"] as? Int ?? Int(AgoraVideoMirrorMode.auto.rawValue))) ?? .auto

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

  @objc public func setupLocalVideoAndPreview(options: [String: Any], webView: UIView) -> String {
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

    DispatchQueue.main.async {
      let videoFrame = CGRect(x: left, y: top, width: width, height: height)
      print("Video frame dimensions:", videoFrame)

      self.videoView = UIView(frame: videoFrame)
      self.videoView?.backgroundColor = .clear
      webView.isOpaque = false
      webView.backgroundColor = .clear

      if let superview = webView.superview {
        superview.insertSubview(self.videoView!, belowSubview: webView)
      } else {
        print("WebView superview not available")
      }

      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.uid = UInt(uid)
      videoCanvas.view = self.videoView
      videoCanvas.renderMode = .hidden

      rtcEngine.setupLocalVideo(videoCanvas)
      print("Local video setup completed for uid: \(uid)")
    }

    rtcEngine.startPreview()
    print("Preview started")
    return "Local video setup and preview started"
  }

}
