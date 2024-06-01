import UIKit

extension UIView {
    func shake() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        shakeAnimation.duration = 0.5
        shakeAnimation.values = [-10, 10, -10, 10, -5, 5, -2, 2, 0]
        layer.add(shakeAnimation, forKey: "shake")
    }

    func makeShadow(shadowOffset: CGSize = CGSize(width: 0, height: 8), color: UIColor = .black) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.withAlphaComponent(0.9).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = 12
    }

    func addFullSize(subView: UIView, cancelIfHasSubView: Bool = true) {
        if cancelIfHasSubView,
           self.subviews.count > 0 {
            // should only add the subview once
            return
        }
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: self.topAnchor),
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = (0..<colors.count).map { NSNumber(value: Double($0) / Double(colors.count - 1)) }
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
