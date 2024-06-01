import SwiftEventBus
import RxSwift
import RxCocoa

public protocol ViewModelTransformable: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
class ViewModel: NSObject {
    var disposeBag: DisposeBag!
    let error = PublishSubject<Error>()
    public override init() {
        disposeBag = DisposeBag()
        super.init()
    }
    deinit {
        #if DEV
        print("\(String(describing: self)) deinit.")
        #endif
    }
}
extension ViewModel {
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
