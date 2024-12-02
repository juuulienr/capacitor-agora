import Foundation
import Capacitor

@objc(AgoraPlugin)
public class AgoraPlugin: CAPPlugin {
  private let agora = Agora()

  // Initialisation d'Agora SDK
  @objc func initialize(_ call: CAPPluginCall) {
    guard let appId = call.getString("appId") else {
      call.reject("Missing App ID")
      return
    }
    do {
      try agora.initialize(appId: appId)
      call.resolve()
    } catch {
      call.reject("Failed to initialize Agora SDK", nil, error)
    }
  }

  // Configurer la vue pour afficher la vidéo
  @objc func setupLocalVideo(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      guard let bridge = self.bridge,
            let viewController = bridge.viewController,
            let parentView = viewController.view else {
        call.reject("Unable to access viewController or its view")
        return
      }

      do {
        try self.agora.setupLocalVideo(in: parentView)
        call.resolve()
      } catch {
        call.reject("Failed to setup local video", nil, error)
      }
    }
  }

  // Rendre la WebView transparente
  @objc func enableWebViewTransparency(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      guard let bridge = self.bridge,
            let webView = bridge.webView else {
        call.reject("Unable to access webView")
        return
      }
      webView.isOpaque = false
      webView.backgroundColor = .clear
      call.resolve()
    }
  }

  // Désactiver la transparence de la WebView
  @objc func disableWebViewTransparency(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      guard let bridge = self.bridge,
            let webView = bridge.webView else {
        call.reject("Unable to access webView")
        return
      }
      webView.isOpaque = true
      webView.backgroundColor = .white
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

    do {
      try agora.joinChannel(channelName: channelName, token: token, uid: uid)
      call.resolve()
    } catch {
      call.reject("Failed to join channel", nil, error)
    }
  }

  // Changer de caméra
  @objc func switchCamera(_ call: CAPPluginCall) {
    do {
      try agora.switchCamera()
      call.resolve()
    } catch {
      call.reject("Failed to switch camera", nil, error)
    }
  }

  // Quitter le canal
  @objc func leaveChannel(_ call: CAPPluginCall) {
    agora.leaveChannel()
    call.resolve()
  }
}
