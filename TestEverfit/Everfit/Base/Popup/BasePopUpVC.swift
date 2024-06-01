import RxSwift
import RxCocoa

private let dimTransparent: CGFloat = 0.5
private let darknessTransitionDuration: TimeInterval = 0.2

class BasePopUpVC: BaseViewController {

    private var tapGesture: UITapGestureRecognizer!
    
    private var containerView: UIView {
        guard let containerView = view.subviews.first else {
            fatalError("Popup must have at least one subviews")
        }
        return containerView
    }
    
    var shouldDismissOnTouchOutside: Bool = false {
        didSet {
            tapGesture.isEnabled = shouldDismissOnTouchOutside
        }
    }
    
    // MARK: Init functions
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .clear
        view.isOpaque = false
        updateUIPopupContainer()
    }
    
    // MARK: - Public funtions
    
    // MARK: - Private functions
    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    private func updateUIPopupContainer() {
        containerView.backgroundColor = .white
        containerView.cornerRadius = 10
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BasePopUpVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasePopupTransitionAnimator(action: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasePopupTransitionAnimator(action: .present)
    }
}

// MARK: - BasePopupTransitionAnimator
class BasePopupTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Action {
        case dismiss
        case present
    }
    
    private let action: Action
    
    // MARK: - Init functions
    init(action: Action) {
        self.action = action
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return darknessTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        var viewController: UIViewController?
        
        // Dim color
        var initialColor: UIColor
        var completedColor: UIColor
        
        // Container View's Position
        var initialY: CGFloat
        var completedY: CGFloat
        
        var completeViewTransparent: CGFloat
        
        switch action {
        case .dismiss:
            viewController = transitionContext.viewController(forKey: .from)
            let containerViewPositionY = viewController?.view.subviews.first?.frame.origin.y ?? 0
            let containerViewHeight = viewController?.view.subviews.first?.frame.height ?? 0
            
            // Container view move from screen to bottom
            initialY = containerViewPositionY
            completedY = containerViewPositionY + containerViewHeight
            
            // Dim color change from black to clear
            initialColor = .black.withAlphaComponent(dimTransparent)
            completedColor = .clear
            
            completeViewTransparent = 0
        case .present:
            viewController = transitionContext.viewController(forKey: .to)
            let containerViewPositionY = viewController?.view.subviews.first?.frame.origin.y ?? 0
            let containerViewHeight = viewController?.view.subviews.first?.frame.height ?? 0
            
            // Container view move from bottom to screen
            initialY = containerViewPositionY + containerViewHeight
            completedY = containerViewPositionY
            
            // Dim color change from clear to black
            initialColor = .clear
            completedColor = .black.withAlphaComponent(dimTransparent)
            
            completeViewTransparent = 1
        }
        guard let controller = viewController, let view = controller.view.subviews.first else { return }
        let duration = transitionDuration(using: transitionContext)
        
        controller.view.frame = containerView.frame
        containerView.addSubview(controller.view)
        
        // Setup start status
        view.frame.origin.y = initialY
        controller.view.backgroundColor = initialColor
        
        UIView.animate(withDuration: duration, animations: {
            // Trasitioning to end status
            view.frame.origin.y = completedY
            controller.view.backgroundColor = completedColor
            view.alpha = completeViewTransparent
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
