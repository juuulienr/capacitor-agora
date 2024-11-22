import Foundation
import AgoraRtcKit

@objc public class Agora: NSObject {
  private var rtcEngine: AgoraRtcEngineKit?

  @objc public func echo(_ value: String) -> String {
    print(value)
    return value
  }

  @objc public func initialize(appId: String) -> String {
    if appId.isEmpty {
      return "Invalid App ID"
    }

    rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    if rtcEngine != nil {
      print("rtcEngine initialized")
      return "Agora initialized successfully"
    } else {
      print("rtcEngine initialization failed")
      return "Agora initialization failed"
    }
  }
}
