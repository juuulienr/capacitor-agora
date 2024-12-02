import Foundation
import Capacitor

/**
 * Capacitor Plugin pour gérer l'intégration d'Agora
 */
@objc(AgoraPlugin)
public class AgoraPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AgoraPlugin"
    public let jsName = "Agora"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setupLocalVideo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "enableWebViewTransparency", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "disableWebViewTransparency", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "joinChannel", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "switchCamera", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "leaveChannel", returnType: CAPPluginReturnPromise)
    ]

    private let implementation = Agora()

    @objc func initialize(_ call: CAPPluginCall) {
        guard let appId = call.getString("appId") else {
            call.reject("Missing App ID")
            return
        }
        do {
            try implementation.initialize(appId: appId)
            call.resolve()
        } catch {
            call.reject("Failed to initialize Agora SDK", nil, error)
        }
    }

    @objc func setupLocalVideo(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let bridge = self.bridge,
                  let viewController = bridge.viewController,
                  let parentView = viewController.view else {
                call.reject("Unable to access viewController or its view")
                return
            }

            do {
                try self.implementation.setupLocalVideo(in: parentView)
                call.resolve()
            } catch {
                call.reject("Failed to setup local video", nil, error)
            }
        }
    }

    @objc func enableWebViewTransparency(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let bridge = self.bridge,
                  let webView = bridge.webView else {
                call.reject("Unable to access webView")
                return
            }
            self.implementation.enableWebViewTransparency(for: webView)
            call.resolve()
        }
    }

    @objc func disableWebViewTransparency(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let bridge = self.bridge,
                  let webView = bridge.webView else {
                call.reject("Unable to access webView")
                return
            }
            self.implementation.disableWebViewTransparency(for: webView)
            call.resolve()
        }
    }

    @objc func joinChannel(_ call: CAPPluginCall) {
        guard let channelName = call.getString("channelName") else {
            call.reject("Missing channel name")
            return
        }
        let token = call.getString("token")
        let uid: UInt = UInt(call.getInt("uid") ?? 0)

        do {
            try implementation.joinChannel(channelName: channelName, token: token, uid: uid)
            call.resolve()
        } catch {
            call.reject("Failed to join channel", nil, error)
        }
    }

    @objc func switchCamera(_ call: CAPPluginCall) {
        do {
            try implementation.switchCamera()
            call.resolve()
        } catch {
            call.reject("Failed to switch camera", nil, error)
        }
    }

    @objc func leaveChannel(_ call: CAPPluginCall) {
        implementation.leaveChannel()
        call.resolve()
    }
}
