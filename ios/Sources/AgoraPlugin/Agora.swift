import Foundation
import AgoraRtcKit
import UIKit

@objc public class Agora: NSObject {
  private var rtcEngine: AgoraRtcEngineKit?
  private var videoView: UIView?

  @objc public func initialize(appId: String) -> String {
    if appId.isEmpty {
      return "Invalid App ID"
    }
    rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    return rtcEngine != nil ? "Agora initialized successfully" : "Agora initialization failed"
  }

  @objc public func createMicrophoneAndCameraTracks() -> String {
    guard let rtcEngine = rtcEngine else { return "Agora not initialized" }

    rtcEngine.enableVideo()
    rtcEngine.enableAudio()

    let config = AgoraVideoEncoderConfiguration(
      size: AgoraVideoDimension1920x1080,
      frameRate: .fps30,
      bitrate: AgoraVideoBitrateStandard,
      orientationMode: .adaptative
    )
    rtcEngine.setVideoEncoderConfiguration(config)
    rtcEngine.startPreview()
    return "Microphone and camera tracks created successfully"
  }

  @objc public func setupLocalVideoAndPreview(webView: UIView) -> String {
    guard let rtcEngine = rtcEngine else { return "Agora not initialized" }

    DispatchQueue.main.async {
      // Configure la vue vidéo pour Agora
      self.videoView = UIView(frame: webView.bounds)
      self.videoView?.backgroundColor = .black // Fond noir pour la caméra
      self.videoView?.layer.zPosition = -1 // Place derrière la WebView
      
      // Configure la WebView
      webView.isOpaque = false
      webView.backgroundColor = .clear
      webView.layer.zPosition = 0

      // Ajoute la vue vidéo derrière la WebView
      webView.superview?.insertSubview(self.videoView!, belowSubview: webView)

      // Configure Agora avec la vue vidéo
      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.uid = 0 // UID local
      videoCanvas.view = self.videoView
      videoCanvas.renderMode = .hidden
      rtcEngine.setupLocalVideo(videoCanvas)
    }

    rtcEngine.startPreview()
    return "Local video setup and preview started"
  }
}
