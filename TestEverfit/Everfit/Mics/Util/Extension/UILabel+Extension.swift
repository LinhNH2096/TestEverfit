import UIKit

extension UILabel {
    func underline(range: NSRange?=nil) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            let range = range ?? NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedText = attributedString
        }
    }
    
    func setLineSpacing(_ lineSpacing: CGFloat, textAlignment: NSTextAlignment = .natural) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        let atributes = [NSAttributedString.Key.paragraphStyle: style]
        self.attributedText = NSAttributedString(string: text.unWrap, attributes: atributes)
        lineBreakMode = .byTruncatingTail
    }

    func addImage(imageName: String) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)

        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: self.text!)
        myString.append(attachmentString)

        self.attributedText = myString
    }

    func setBottomBorder(color: UIColor?, width: CGFloat = 1.0) {
        let rect = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        let border = UIView(frame: rect)
        border.backgroundColor = color
        border.autoresizingMask = {
            return [.flexibleWidth, .flexibleTopMargin]
        }()
        addSubview(border)
    }
}
