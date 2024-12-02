import Foundation
import AgoraRtcKit

class Agora {
  private var agoraKit: AgoraRtcEngineKit?
  private var localVideoView: UIView?

  // Initialisation de l'Agora SDK
  func initialize(appId: String) throws {
    self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
  }

  // Configurer la vue pour afficher la vidéo
  func setupLocalVideo(in parentView: UIView) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }

    DispatchQueue.main.async {
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = UIView(frame: parentView.bounds)
      self.localVideoView?.backgroundColor = .black
      parentView.insertSubview(self.localVideoView!, at: 0)

      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.view = self.localVideoView
      videoCanvas.renderMode = .hidden
      videoCanvas.uid = 0
      agoraKit.setupLocalVideo(videoCanvas)
    }
  }

  // Rejoindre un canal
  func joinChannel(channelName: String, token: String?, uid: UInt) throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }
    agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid, joinSuccess: nil)
  }

  // Changer de caméra
  func switchCamera() throws {
    guard let agoraKit = self.agoraKit else {
      throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
    }
    agoraKit.switchCamera()
  }

  // Quitter le canal
  func leaveChannel() {
    agoraKit?.leaveChannel(nil)
    DispatchQueue.main.async {
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = nil
    }
  }
}
