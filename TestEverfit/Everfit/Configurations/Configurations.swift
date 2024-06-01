import Foundation

enum ConfigurationKey: String {
    case appName = "APP_NAME"
    case appVersion = "APP_VERSION"
    case appBuild = "APP_BUILD"
    case bundleID = "BUNDLE_ID"

    func value() -> String? {
        return (Bundle.main.infoDictionary?[self.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}
