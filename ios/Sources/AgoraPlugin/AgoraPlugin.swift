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

  @objc func echo(_ call: CAPPluginCall) {
    let value = call.getString("value") ?? ""
    call.resolve([
      "value": implementation.echo(value)
    ])
  }

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
}
