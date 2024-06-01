import UIKit
import IQKeyboardManagerSwift
import netfox

// MARK: - Configurable
protocol ApplicationConfigurable {
    var window: UIWindow? { get set }

    func applicationRoute(from: UIWindow)
    func setRoot(window: UIWindow, view: UIViewController)

    func setup()
    func shutDown()

    func toTabbar()
}

extension ApplicationConfigurable {
    func setRoot(window: UIWindow, view: UIViewController) {
        UIView.transition(with: window, duration: 0.22, options: .transitionFlipFromRight, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = view
            UIView.setAnimationsEnabled(oldState)
        })
    }
}

// MARK: - Configuration Implementation
class ApplicationConfiguration: ApplicationConfigurable {
    var window: UIWindow?

    func applicationRoute(from window: UIWindow) {
        self.window = window
        let mainNavigation = UINavigationController(rootViewController: HomeViewController())
        mainNavigation.isNavigationBarHidden = true
        setRoot(window: window, view: mainNavigation)
    }

    func setup() {
        self.setupNavigationBarAppearance()
        self.setupKeyboard()
        self.setupNetfox()
    }

    func shutDown() {
        self.stopNetfox()
    }

    func toTabbar() {
        guard let window = self.window else { return }
        let mainNavigation = UINavigationController(rootViewController: MainTabbarViewController())
        mainNavigation.isNavigationBarHidden = true
        setRoot(window: window, view: mainNavigation)
    }
}

extension ApplicationConfiguration {
    private func setupNetfox() {
        #if DEV
        NFX.sharedInstance().start()
        #endif
    }

    private func stopNetfox() {
        #if DEV
        NFX.sharedInstance().stop()
        #endif
    }

    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }

    private func setupNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = AppColor.appBackground
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: AppFont.roboto(name: .bold, size: 16),
                                                       NSAttributedString.Key.foregroundColor: AppColor.main]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
