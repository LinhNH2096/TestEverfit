import UIKit

// MARK: - Screen size
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let appDelegate = UIApplication.shared.delegate

// MARK: - Iphone
let isIpad = UIDevice.current.userInterfaceIdiom == .pad
let isIphone = UIDevice.current.userInterfaceIdiom == .phone
let isIphoneXLayout = (isIphone && (UIScreen.main.bounds.height >= 812)) // iphone XR,XSMax = 896 --- X,XS = 812
let isIphone4 = (isIphone && (UIScreen.main.nativeBounds.height == 480))
let isIphone5 = (isIphone && (UIScreen.main.nativeBounds.height == 568))
let isIphone678 = (isIphone && (UIScreen.main.bounds.height == 667))
let isIphone678Plus = (isIphone && (UIScreen.main.bounds.height == 736))
let isOldIPadRatio = UIScreen.main.nativeBounds.height/UIScreen.main.nativeBounds.width == 960/640

// MARK: - App Constant
struct Constant {
    static let tabbarAdsBannerHeight: CGFloat = 60
}
