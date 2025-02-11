import SystemConfiguration
import UIKit

// swiftlint:disable all
class DeviceManager {

    class func getDeviceName() -> NSString {
        return UIDevice.current.name as NSString
    }

    class func getDeviceSystemName() -> NSString {
        return UIDevice.current.systemName as NSString
    }

    class func getWinSize() -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenSize = screenRect.size
        return screenSize
    }

    class func getWinFrame() -> CGRect {
        let screenRect = UIScreen.main.bounds
        let screenFrame = screenRect
        return screenFrame
    }

    class func getNewFeedsWidth() -> CGFloat {
        return DeviceManager.getWinSize().width - ((DeviceManager.getWinSize().width - 40) / 4 + 20 )
    }

    func getDeviceID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    class func isIphone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }

    class func isIpad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }

    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    struct DeviceType {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(DeviceType.SCREEN_WIDTH, DeviceType.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(DeviceType.SCREEN_WIDTH, DeviceType.SCREEN_HEIGHT)
        static let IS_IPHONE_X_OR_MORE = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH >= 812
        static let IS_IPHONE_8_OR_LOWER = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH <= 667
    }

    class func detectInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()

        guard let defaultRouteReachability = defaultRouteReachability else {
            return false
        }

        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    class func  isLandscape() -> Bool {
        return UIApplication.shared.windows
                        .first?
                        .windowScene?
                        .interfaceOrientation
                        .isLandscape ?? false
    }

    class func isPortrait() -> Bool {
        return UIApplication.shared.windows
                        .first?
                        .windowScene?
                        .interfaceOrientation
                        .isPortrait ?? false
    }

    class func getDirectPath() -> String {
        let directoryURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)

        if !directoryURLs.isEmpty {
            return directoryURLs[0].absoluteString
        }
        return ""
    }
}
