import UIKit

enum RobotoFontName: String {
    case black = "Roboto-Black"
    case bold = "Roboto-Bold"
    case light = "Roboto-Light"
    case medium = "Roboto-Medium"
    case regular = "Roboto-Regular"
    case thin = "Roboto-Thin"

    var name: String {
        return rawValue
    }
}

struct AppFont {
    static func roboto(name: RobotoFontName = .regular,
                      size: CGFloat) -> UIFont {
        return UIFont(name: name.name, size: size) ?? UIFont.mySystemFont(ofSize: size)
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: RobotoFontName.regular.name, size: size) {
            return font
        }
        return UIFont(name: RobotoFontName.regular.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: RobotoFontName.bold.name, size: size) {
            return font
        }
        return UIFont(name: RobotoFontName.bold.name, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: RobotoFontName.light.name, size: size) {
            return font
        }
        return UIFont(name: RobotoFontName.light.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: RobotoFontName.medium.name, size: size) {
            return font
        }
        return UIFont(name: RobotoFontName.medium.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func mySemiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: RobotoFontName.bold.name, size: size) {
            return font
        }
        return UIFont(name: RobotoFontName.bold.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc convenience init?(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }

        var fontName = ""
        switch fontAttribute {
        case "CTFontEmphasizedUsage", "CTFontBoldUsage", "CTFontDemiUsage":
            fontName = RobotoFontName.bold.name
        case "CTFontObliqueUsage":
            fontName = RobotoFontName.light.name
        case "CTFontMediumUsage":
            fontName = RobotoFontName.medium.name
        default:
            fontName = RobotoFontName.regular.name
        }

        self.init(name: fontName, size: fontDescriptor.pointSize)
    }

    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

