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
            self.localVideoView?.backgroundColor = .clear
            self.localVideoView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

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
            agoraKit.enableVideo()
            agoraKit.startPreview()
            print("[Agora] Video preview started")
        }
    }

    public func enableWebViewTransparency(for webView: UIView) {
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        print("[Agora] WebView transparency enabled")
    }

    public func disableWebViewTransparency(for webView: UIView) {
        webView.isOpaque = true
        webView.backgroundColor = .white
    }

    public func joinChannel(channelName: String, token: String?, uid: UInt) throws {
        guard let agoraKit = self.agoraKit else {
            throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
        }
        agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid, joinSuccess: nil)
    }

    public func switchCamera() throws {
        guard let agoraKit = self.agoraKit else {
            throw NSError(domain: "Agora", code: -1, userInfo: [NSLocalizedDescriptionKey: "Agora not initialized"])
        }
        agoraKit.switchCamera()
    }

    public func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        DispatchQueue.main.async {
            self.localVideoView?.removeFromSuperview()
            self.localVideoView = nil
        }
    }
}
