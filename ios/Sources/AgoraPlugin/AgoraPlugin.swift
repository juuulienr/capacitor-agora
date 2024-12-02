import Foundation
import Capacitor
import AgoraRtcKit

@objc(AgoraPlugin)
public class AgoraPlugin: CAPPlugin {
  private var agoraKit: AgoraRtcEngineKit?
  private var localVideoView: UIView?

  // Initialisation d'Agora SDK
  @objc func initialize(_ call: CAPPluginCall) {
    guard let appId = call.getString("appId") else {
      call.reject("Missing App ID")
      return
    }
    agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    call.resolve()
  }

  // Configurer la vue pour afficher la vidéo
  @objc func setupLocalVideo(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      guard let agoraKit = self.agoraKit else {
        call.reject("Agora not initialized")
        return
      }

      // Crée une vue pour la vidéo locale
      let bounds = self.bridge.viewController.view.bounds
      self.localVideoView = UIView(frame: bounds)
      self.localVideoView?.backgroundColor = .black
      self.bridge.viewController.view.insertSubview(self.localVideoView!, at: 0)

      let videoCanvas = AgoraRtcVideoCanvas()
      videoCanvas.view = self.localVideoView
      videoCanvas.renderMode = .hidden
      videoCanvas.uid = 0
      agoraKit.setupLocalVideo(videoCanvas)

      call.resolve()
    }
  }

  // Rendre la WebView transparente
  @objc func enableWebViewTransparency(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      if let webView = self.bridge.webView {
        webView.isOpaque = false
        webView.backgroundColor = .clear
      }
      call.resolve()
    }
  }

  // Désactiver la transparence de la WebView
  @objc func disableWebViewTransparency(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      if let webView = self.bridge.webView {
        webView.isOpaque = true
        webView.backgroundColor = .white // Couleur par défaut de fond
      }
      call.resolve()
    }
  }

  // Rejoindre un canal vidéo
  @objc func joinChannel(_ call: CAPPluginCall) {
    guard let channelName = call.getString("channelName") else {
      call.reject("Missing channel name")
      return
    }
    let token = call.getString("token")
    let uid: UInt = UInt(call.getInt("uid") ?? 0)

    agoraKit?.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) { _, _, _ in
      call.resolve()
    }
  }

  // Changer de caméra
  @objc func switchCamera(_ call: CAPPluginCall) {
    agoraKit?.switchCamera()
    call.resolve()
  }

  // Quitter le canal
  @objc func leaveChannel(_ call: CAPPluginCall) {
    agoraKit?.leaveChannel(nil)
    DispatchQueue.main.async {
      self.localVideoView?.removeFromSuperview()
      self.localVideoView = nil
    }
    call.resolve()
  }
}
