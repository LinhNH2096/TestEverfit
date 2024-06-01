import Foundation

typealias UserDefaultKey = AppDefine.UserDefineKey

public enum AppDefine {
    
    enum UserDefineKey: String {
        var desc: String {
            return rawValue
        }
        case isFirstLaunch
    }
}
