import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    override init() {
        super.init()
        UIFont.overrideInitialize()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        ServiceFacade.registerDefaultService(from: window!)
        self.animationSplash()
        return true
    }

    func animationSplash() {
        let splashVC = LaunchScreenAnimationViewController()
        splashVC.delegate = self
        window?.rootViewController = splashVC
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ServiceFacade.shutDownAllService()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {}


}

extension AppDelegate: LaunchScreenAnimationDelegate {
    func splashAnimationDidFinish() {
        guard let window = self.window else { return }
        ServiceFacade.applicationService.applicationRoute(from: window)
    }
}
