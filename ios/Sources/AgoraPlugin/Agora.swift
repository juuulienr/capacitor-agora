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

    public func enableWebViewTransparency(for webView: UIView) {
        webView.isOpaque = false
        webView.backgroundColor = .clear
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
