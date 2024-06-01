import UIKit
import SwiftEventBus

enum AppTabbarItem: Int, CaseIterable {
    case tab1 = 0
    case tab2
    case tab3
    case tab4

    var tabIndex: Int {
        return rawValue
    }

    var titleItem: String {
        switch self {
        case .tab1:
            return "Tab 1"
        case .tab2:
            return "Tab 2"
        case .tab3:
            return "Tab 3"
        case .tab4:
            return "Tab 4"
        }
    }

    var icon: UIImage? {
        switch self {
        case .tab1:
            return UIImage(named: "ic_tabbar1")
        case .tab2:
            return UIImage(named: "ic_tabbar2")
        case .tab3:
            return UIImage(named: "ic_tabbar3")
        case .tab4:
            return UIImage(named: "ic_tabbar4")
        }
    }

    var viewController: UIViewController {
        switch self {
        case .tab1:
            let remoteVC = BaseViewController()
            remoteVC.isTabViewController = true
            return remoteVC
        case .tab2:
            let controlVC = BaseViewController()
            controlVC.isTabViewController = true
            return controlVC
        case .tab3:
            let mirroringVC = BaseViewController()
            mirroringVC.isTabViewController = true
            return mirroringVC
        case .tab4:
            let settingsVC = BaseViewController()
            settingsVC.isTabViewController = true
            return settingsVC
        }
    }
}

class MainTabbarViewController: UITabBarController {

    private let selectedColor: UIColor = AppColor.selected ?? .blue
    private let normalColor: UIColor = .white
    private let itemImageSize: CGSize = CGSize(width: 24, height: 24)

    override func viewDidLoad() {
        super.viewDidLoad()


        self.setup()
        self.createTabbar()
    }

    private func setup() {
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.tintColor = selectedColor
        self.tabBar.unselectedItemTintColor = normalColor
    }

    private func createTabbar() {
        let tabbarViewControllers: [UIViewController] = AppTabbarItem.allCases.map { item -> UIViewController in
            let tabbarIcon = item.icon?.resize(to: itemImageSize)?.withRenderingMode(.alwaysOriginal)
            let tabbarItem = UITabBarItem(title: item.titleItem,
                                          image: tabbarIcon?.withTintColor(normalColor),
                                          selectedImage: tabbarIcon?.withTintColor(selectedColor))
            let viewController = item.viewController
            viewController.tabBarItem = tabbarItem
            return viewController
        }
        self.viewControllers = tabbarViewControllers
        self.tabBar.backgroundColor = AppColor.appBackground
    }
}
