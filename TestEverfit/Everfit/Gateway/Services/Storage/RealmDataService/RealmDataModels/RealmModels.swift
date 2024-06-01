import RealmSwift

// MARK: Convertable
protocol RealmRepresentable {
    associatedtype RealmType

    func asRealmType() -> RealmType
}

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomainType() -> DomainType
}
