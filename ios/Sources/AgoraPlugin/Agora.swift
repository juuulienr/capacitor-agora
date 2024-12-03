import Foundation
import AgoraRtcKit

/**
 * Classe Agora qui encapsule la logique SDK d'Agora
 */
@objc public class Agora: NSObject {
  private var agoraKit: AgoraRtcEngineKit?
  private var localVideoView: UIView?

  public func initialize(appId: String) throws {
    self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)

    // Active la vidéo
    self.agoraKit?.enableVideo()
    print("[Agora] Video enabled")

    // Active l’audio
    self.agoraKit?.enableAudio()
    print("[Agora] Audio enabled")

    // Configure la qualité vidéo au démarrage
    let videoConfig = AgoraVideoEncoderConfiguration(
      size: AgoraVideoDimension1920x1080,
      frameRate: .fps30,
      bitrate: AgoraVideoBitrateStandard,
      orientationMode: .fixedPortrait,
      mirrorMode: .disabled
    )

    self.agoraKit?.setVideoEncoderConfiguration(videoConfig)
  }

  public func setupLocalVideo(in parentView: UIView) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    DispatchQueue.main.async {
      // Supprime toute vue existante
      self.localVideoView?.removeFromSuperview()
      print("[Agora] Removed existing localVideoView")

      // Configure la nouvelle vue pour la vidéo locale
      self.localVideoView = UIView(frame: parentView.bounds)
      self.localVideoView?.backgroundColor = .black
      self.localVideoView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      // Configure la transparence pour les WebView
      parentView.isOpaque = false
      parentView.backgroundColor = .clear
      if let scrollView = parentView as? UIScrollView {
        scrollView.backgroundColor = .clear
      }
      print("[Agora] WebView transparency enabled in setupLocalVideo")

      // Ajoute la vue en arrière-plan
      parentView.insertSubview(self.localVideoView!, at: 0)
      print("[Agora] Inserted localVideoView behind ParentView content")

      // Configure le rendu Agora
      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.view = self.localVideoView
      videoCanvas.renderMode = .hidden
      videoCanvas.uid = 0
      agoraKit.setupLocalVideo(videoCanvas)
      print("[Agora] Configured Agora video canvas")

      // Démarre la prévisualisation
      agoraKit.startPreview()
      print("[Agora] Video preview started")
    }
  }

  public func joinChannel(channelName: String, token: String?, uid: UInt) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    // Active l'audio et la vidéo
    agoraKit.muteLocalAudioStream(false)
    agoraKit.muteLocalVideoStream(false)
    agoraKit.setClientRole(.broadcaster)
    agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) { [weak self] channel, uid, elapsed in
      print("[Agora] Joined channel \(channel) with UID \(uid), elapsed \(elapsed) ms")
    }
  }

  public func switchCamera() throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }
    agoraKit.switchCamera()
  }

  public func leaveChannel(for parentView: UIView) {
    agoraKit?.leaveChannel(nil)
    DispatchQueue.main.async {
      // Supprime la vue locale
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = nil

      // Désactive la transparence des WebView
      parentView.isOpaque = true
      parentView.backgroundColor = .white
      if let scrollView = parentView as? UIScrollView {
        scrollView.backgroundColor = .white
      }
      print("[Agora] WebView transparency disabled in leaveChannel")
    }
  }
}
