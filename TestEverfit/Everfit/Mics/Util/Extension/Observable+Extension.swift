import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
    internal func ignoreNil() -> Driver<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<Element.Wrapped>.just($0) } ?? Driver<Element.Wrapped>.empty()
        }
    }
}

extension Optional: OptionalType {

    public var optional: Wrapped? { return self }
    public var notNil: Bool {
        return self != nil
    }
    public var isNil: Bool {
        return self == nil
    }

    public var unWrap: String {
        if let number = self as? NSNumber {
            return "\(number)"
        }
        return self as? String ?? ""
    }

    var unWrapNumber: Int {
        return self as? Int ?? 0
    }

    var unWrapDate: Date {
        return self as? Date ?? Date()
    }

    public var unWrapArray: [String] {
        return self as? [String] ?? []
    }
    
    public var unWrapDic: [String: String] {
        return self as? [String: String] ?? [:]
    }

    var unWrapFont: UIFont {
        return self as? UIFont ?? UIFont()
    }
}
