import UIKit

extension UIViewController {
    func setupTransparentPopupPresent() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    }
}
