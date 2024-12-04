import AVFoundation
import AgoraRtcKit
import UIKit

/// Classe Agora qui encapsule la logique SDK d'Agora
@objc public class Agora: NSObject {
  private var agoraKit: AgoraRtcEngineKit?
  private var localVideoView: UIView?

  public func initialize(appId: String) throws {
    let agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    self.agoraKit = agoraKit

    // Configure la qualité vidéo
    let videoConfig = AgoraVideoEncoderConfiguration(
      size: AgoraVideoDimension1920x1080,
      frameRate: .fps30,
      bitrate: AgoraVideoBitrateStandard,
      orientationMode: .fixedPortrait,
      mirrorMode: .disabled
    )
    agoraKit.setVideoEncoderConfiguration(videoConfig)
    agoraKit.enableVideo()
  }

  public func requestPermissions(completion: @escaping (Bool) -> Void) {
    let dispatchGroup = DispatchGroup()

    var isCameraAccessGranted = false
    var isMicrophoneAccessGranted = false

    // Demande d'accès à la caméra
    dispatchGroup.enter()
    AVCaptureDevice.requestAccess(for: .video) { granted in
      isCameraAccessGranted = granted
      print("[Agora] Camera access \(granted ? "granted" : "denied")")
      dispatchGroup.leave()
    }

    // Demande d'accès au microphone
    dispatchGroup.enter()
    AVCaptureDevice.requestAccess(for: .audio) { granted in
      isMicrophoneAccessGranted = granted
      print("[Agora] Microphone access \(granted ? "granted" : "denied")")
      dispatchGroup.leave()
    }

    // Après avoir vérifié les autorisations
    dispatchGroup.notify(queue: .main) {
      if isCameraAccessGranted && isMicrophoneAccessGranted {
        completion(true)
      } else {
        self.openAppSettings()
        completion(false)
      }
    }
  }

  private func openAppSettings() {
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
      // Configure la nouvelle vue pour la vidéo locale
      self.localVideoView = UIView(frame: parentView.bounds)

      // Ajoute la vue en arrière-plan
      parentView.insertSubview(self.localVideoView!, at: 0)
      parentView.isOpaque = false
      parentView.backgroundColor = .clear
      parentView.scrollView.backgroundColor = .clear
      print("[Agora] Inserted localVideoView behind ParentView content")

      // Configure le rendu Agora
      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.view = self.localVideoView
      videoCanvas.uid = 0
      agoraKit.setupLocalVideo(videoCanvas)
      print("[Agora] Configured Agora video canvas")

      // Démarre la prévisualisation
      agoraKit.startPreview()
      print("[Agora] Video preview started")
      print("[Agora] WebView transparency enabled in setupLocalVideo")
    }
  }

  public func joinChannel(channelName: String, token: String?, uid: UInt) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(
        domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    // Active l'audio et la vidéo (évite la popup plus tard)
    agoraKit.muteLocalAudioStream(false)
    agoraKit.muteLocalVideoStream(false)
    agoraKit.setClientRole(.broadcaster)

    agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) {
      [weak self] channel, uid, elapsed in
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

    // Arrête la capture vidéo et désactive la vidéo
    agoraKit.stopPreview()
    agoraKit.enableLocalVideo(false)
    print("[Agora] Camera preview stopped and local video disabled")

    // Désactive l’audio si nécessaire
    agoraKit.muteLocalAudioStream(true)
    print("[Agora] Local audio muted")

    // Quitte le canal
    agoraKit.leaveChannel(nil)
    print("[Agora] Left channel")

    DispatchQueue.main.async {
      // Supprime la vue locale
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = nil

      // Désactive la transparence des WebView
      parentView.isOpaque = true
      parentView.backgroundColor = .white
      parentView.scrollView.backgroundColor = .clear
      print("[Agora] WebView transparency disabled in leaveChannel")
    }
  }
}
