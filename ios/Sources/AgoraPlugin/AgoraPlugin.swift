import Foundation
import Capacitor

@objc(AgoraPlugin)
public class AgoraPlugin: CAPPlugin, CAPBridgedPlugin {
  public let identifier = "AgoraPlugin"
  public let jsName = "Agora"
  public let pluginMethods: [CAPPluginMethod] = [
    CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
    CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise)
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
    guard let options = call.options else {
    call.reject("Invalid options")
    return
    }

    let result = implementation.createMicrophoneAndCameraTracks(options: options)
    if result.contains("successfully") {
    call.resolve(["message": result])
    } else {
    call.reject(result)
    }
  }  
  
  @objc func setupLocalVideo(_ call: CAPPluginCall) {
    guard let options = call.options else {
      call.reject("Invalid options")
      return
    }

    // Passe la WebView actuelle comme paramètre
    guard let webView = self.bridge?.webView else {
      call.reject("WebView not available")
      return
    }

    let result = implementation.setupLocalVideo(options: options, webView: webView)
    if result.contains("completed") {
      call.resolve(["message": result])
    } else {
      call.reject(result)
    }
  }

  @objc func startPreview(_ call: CAPPluginCall) {
    let result = implementation.startPreview()
    if result.contains("started") {
      call.resolve(["message": result])
    } else {
      call.reject(result)
    }
  }

}
