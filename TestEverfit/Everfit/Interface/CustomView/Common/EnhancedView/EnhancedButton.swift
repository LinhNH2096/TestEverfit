import UIKit

class EnhancedButton: UIButton {

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
        setupDropShadow()
        setupTouchEffect()
    }

    func setup() {}

    // MARK: Gradient
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var middleColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var gradientDirection: Int = GradientDirection.horizontal.rawValue {
        didSet {
            if let direction = GradientDirection(rawValue: gradientDirection) {
                self.internalGradientDirection = direction
            }
        }
    }

    private var internalGradientDirection: GradientDirection = .horizontal {
        didSet {
            setNeedsLayout()
        }
    }

    private func setupGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        switch internalGradientDirection {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: DropShadow
    @IBInspectable var enableDropShadow: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    private func setupDropShadow() {
        if enableDropShadow {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.45
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowRadius = 5
        } else {
            layer.shadowOpacity = 0
        }
    }

    // MARK: TouchEffect
    @IBInspectable var enableEffect: Bool = true
    @IBInspectable var scaleFactor: CGFloat = 0.97
    
    @IBInspectable var brightnessFactor: CGFloat = 0.98 {
        didSet {
            setNeedsLayout()
        }
    }

    private func setupTouchEffect() {
        self.alpha = self.brightnessFactor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard enableEffect else { return }
        self.handleTouchDown()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard enableEffect else { return }
        self.handleTouchUp()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard enableEffect else { return }
        self.handleTouchUp()
    }

    @objc private func handleTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
            self.frame.origin.y += 2.0
            self.alpha = self.brightnessFactor
        }
    }

    @objc private func handleTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.transform = .identity
            self.frame.origin.y -= 2.0
            self.alpha = 1.0
        }
    }
}
