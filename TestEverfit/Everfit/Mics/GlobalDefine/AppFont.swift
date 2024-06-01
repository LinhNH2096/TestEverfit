import UIKit

enum OpenSanFontName: String {
    case bold = "OpenSans-Bold"
    case boldItalic = "OpenSans-BoldItalic"
    case extraBold = "OpenSans-ExtraBold"
    case extraBoldItalic = "OpenSans-ExtraBoldItalic"
    case italic = "OpenSans-Italic"
    case light = "OpenSans-Light"
    case lightItalic = "OpenSans-LightItalic"
    case medium = "OpenSans-Medium"
    case mediumItalic = "OpenSans-MediumItalic"
    case regular = "OpenSans-Regular"
    case semiBold = "OpenSans-SemiBold"
    case semiBoldItalic = "OpenSans-SemiBoldItalic"

    var name: String {
        return rawValue
    }
}

struct AppFont {
    static func openSans(name: OpenSanFontName = .regular,
                         size: CGFloat) -> UIFont {
        return UIFont(name: name.name, size: size) ?? UIFont.mySystemFont(ofSize: size)
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: OpenSanFontName.regular.name, size: size) {
            return font
        }
        return UIFont(name: OpenSanFontName.regular.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: OpenSanFontName.bold.name, size: size) {
            return font
        }
        return UIFont(name: OpenSanFontName.bold.name, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: OpenSanFontName.italic.name, size: size) {
            return font
        }
        return UIFont(name: OpenSanFontName.italic.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: OpenSanFontName.medium.name, size: size) {
            return font
        }
        return UIFont(name: OpenSanFontName.medium.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    @objc class func mySemiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: OpenSanFontName.semiBold.name, size: size) {
            return font
        }
        return UIFont(name: OpenSanFontName.semiBold.name, size: size) ?? UIFont.systemFont(ofSize: size)
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
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = OpenSanFontName.bold.name
        case "CTFontDemiUsage":
            fontName = OpenSanFontName.semiBold.name
        case "CTFontObliqueUsage":
            fontName = OpenSanFontName.italic.name
        case "CTFontMediumUsage":
            fontName = OpenSanFontName.medium.name
        default:
            fontName = OpenSanFontName.regular.name
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

