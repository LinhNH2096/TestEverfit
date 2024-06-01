import UIKit

extension UIStackView {
    func reset() {
        self.subviews.forEach { subview in
            self.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
