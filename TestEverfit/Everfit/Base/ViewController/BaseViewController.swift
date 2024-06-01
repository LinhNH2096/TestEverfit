import SwifterSwift
import RxCocoa
import RxSwift
import SwiftEventBus
import AudioToolbox
import SVProgressHUD

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    var backgroundImageView: UIImageView?
    var blurBackgroundView: UIVisualEffectView?
    let feedBackGenerator = UISelectionFeedbackGenerator()

    var isTabViewController: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColor.appBackground
        self.feedBackGenerator.prepare()
        #if DEV
        debugPrint("\(String(describing: type(of: self))) INIT.")
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }

    deinit {
        #if DEV
        debugPrint("\(String(describing: type(of: self))) DEINIT.")
        #endif
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImageView?.frame = view.bounds
        self.blurBackgroundView?.frame = self.backgroundImageView?.bounds ?? .zero
    }
}


// MARK: - Setup navigation
extension BaseViewController {
    enum BarButtonItemType {
        case back
        case close
        case refresh
        case multi([BarButtonItemType])

        var image: UIImage? {
            switch self {
            case .back: return UIImage(named: "ic_back")
            case .refresh: return UIImage(named: "ic_refresh")
            case .close: return UIImage(named: "ic_close")
            default: return nil
            }
        }
    }

    func updateNavigationBar(title: String? = nil,
                             leftType: BarButtonItemType? = nil,
                             rightType: BarButtonItemType? = nil) {
        var leftItems: [UIBarButtonItem] = []
        var rightItems: [UIBarButtonItem] = []

        if let leftType = leftType {
            switch leftType {
            case .multi(let types):
                leftItems = types.map({ UIBarButtonItem(customView: customImageBarButtonItem(type: $0)) })
            default:
                leftItems = [UIBarButtonItem(customView: customImageBarButtonItem(type: leftType))]
            }
        }

        if let rightType = rightType {
            switch rightType {
            case .multi(let types):
                rightItems = types.map({ UIBarButtonItem(customView: customImageBarButtonItem(type: $0)) })
            default:
                rightItems = [UIBarButtonItem(customView: customImageBarButtonItem(type: rightType))]
            }
        }

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                                                   NSAttributedString.Key.foregroundColor: AppColor.main]
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = AppColor.appBackground
        navigationController?.navigationBar.tintColor = AppColor.main

        navigationItem.hidesBackButton = true
        navigationItem.title = title
        navigationItem.leftBarButtonItems = leftItems
        navigationItem.rightBarButtonItems = rightItems
    }

    private func customImageBarButtonItem(type: BarButtonItemType) -> UIView {
        let button = UIButton(type: .custom)
        button.setImage(type.image?.withTintColor(AppColor.main), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        switch type {
        case .back:
            button.addTarget(self, action: #selector(didSelectBack), for: .touchUpInside)
        case .refresh:
            button.addTarget(self, action: #selector(didSelectRefresh), for: .touchUpInside)
        case .close:
            button.addTarget(self, action: #selector(didSelectClose), for: .touchUpInside)
        default: break
        }
        return button
    }

    @objc func didSelectBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func didSelectRefresh() {
        print("didSelectRefresh")
    }

    @objc func didSelectClose() {
        print("didSelectClose")
        self.dismiss(animated: true)
    }
}

extension BaseViewController {
    func register(name aName: Notification.Name, handler: @escaping (Any?) -> Void) {
        SwiftEventBus.on(self, name: aName.rawValue, queue: nil) { (notification) in
            handler(notification?.object)
        }
    }
    func unregister(name aName: Notification.Name) {
        SwiftEventBus.unregister(self, name: aName.rawValue)
    }
    func unregisterAll() {
        SwiftEventBus.unregister(self)
    }
    func post(name aName: Notification.Name, object: Any?) {
        SwiftEventBus.post(aName.rawValue, sender: object)
    }
}

extension BaseViewController {
    func showToast(message: String, topSpacing: CGFloat = 57) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = AppColor.appBackground
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0

        let toastX: CGFloat = 2
        let toastY: CGFloat = UIApplication.shared.statusBarFrame.height + topSpacing
        let toastWidth: CGFloat = view.frame.size.width - 4
        let toastHeight: CGFloat = 44

        toastLabel.cornerRadius = 1
        toastLabel.frame = CGRect(x: toastX,
                                  y: toastY,
                                  width:toastWidth,
                                  height: 0)
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.frame = CGRect(x: toastX,
                                      y: toastY,
                                      width:toastWidth,
                                      height: toastHeight)
            toastLabel.alpha = 1.0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            }
        })
    }
}

extension Reactive where Base: BaseViewController {
    var onLoading: Binder<Bool> {
        Binder(base) { _, isShow in
            SVProgressHUD.setDefaultMaskType(.clear)
            DispatchQueue.main.async {
                if isShow {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

    var onErrorMessage: Binder<String> {
        Binder(base) { this, message in
            this.showAlert(title: nil, message: message)
        }
    }

    var dismiss: Binder<Void> {
        return Binder(base) { this, _ in
            this.dismiss(animated: true, completion: nil)
        }
    }

    var presentViewController: Binder<UIViewController> {
        return Binder(base) { this, viewController in
            this.present(viewController, animated: true)
        }
    }

    var pushViewController: Binder<UIViewController> {
        return Binder(base) { this, viewController in
            this.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    var popViewController: Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popViewController(animated: true)
        }
    }

    var popToRootViewController: Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popToRootViewController(animated: true)
        }
    }
}

func errorHapticFeedback() {
    if #available(iOS 10.0, *) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
