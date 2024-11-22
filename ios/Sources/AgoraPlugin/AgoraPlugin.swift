import Foundation
import Capacitor

@objc(AgoraPlugin)
public class AgoraPlugin: CAPPlugin, CAPBridgedPlugin {
  public let identifier = "AgoraPlugin"
  public let jsName = "Agora"
  public let pluginMethods: [CAPPluginMethod] = [
    CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
    CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
    CAPPluginMethod(name: "createMicrophoneAndCameraTracks", returnType: CAPPluginReturnPromise),
    CAPPluginMethod(name: "setupLocalVideoAndPreview", returnType: CAPPluginReturnPromise)
  ]

  private let implementation = Agora()

  @objc func initialize(_ call: CAPPluginCall) {
    guard let appId = call.getString("appId") else {
      call.reject("Invalid App ID")
      return
    }

    let result = implementation.initialize(appId: appId)
    if result.contains("successfully") {
      call.resolve(["message": result])
    } else {
      call.reject(result)
    }
  }

  @objc func createMicrophoneAndCameraTracks(_ call: CAPPluginCall) {
    guard let rawOptions = call.options as? [String: Any] else {
      call.reject("Invalid options")
      return
    }

    let result = implementation.createMicrophoneAndCameraTracks(options: rawOptions)
    if result.contains("successfully") {
      call.resolve(["message": result])
    } else {
      call.reject(result)
    }
  }

    
  @objc func setupLocalVideoAndPreview(_ call: CAPPluginCall) {
    guard let rawOptions = call.options as? [String: Any] else {
      call.reject("Invalid options")
      return
    }

    guard let webView = self.bridge?.webView else {
      call.reject("WebView not available")
      return
    }

    let result = implementation.setupLocalVideoAndPreview(options: rawOptions, webView: webView)
    if result.contains("started") {
      call.resolve(["message": result])
    } else {
      call.reject(result)
    }
  }

}
