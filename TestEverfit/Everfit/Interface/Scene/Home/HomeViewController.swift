import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    private func setupUI() {
        self.updateNavigationBar(title: "Home",
                                 leftType: .refresh,
                                 rightType: .close)

    }

}
