import UIKit

protocol LaunchScreenAnimationDelegate: AnyObject {
    func splashAnimationDidFinish()
}

class LaunchScreenAnimationViewController: UIViewController {
    
    weak var delegate: LaunchScreenAnimationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.startLoading()
    }
}

// MARK: - Private Method
private extension LaunchScreenAnimationViewController {
    func setupUI() {}

    func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.delegate?.splashAnimationDidFinish()
        }
    }
}
