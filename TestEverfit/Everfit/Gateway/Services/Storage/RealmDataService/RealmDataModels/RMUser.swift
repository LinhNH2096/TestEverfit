import RealmSwift

class RMUser: Object, DomainConvertibleType {

    typealias DomainType = User

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""

    convenience init(id: String = "",
                     name: String = "") {
        self.init()
        self.id = id
        self.name = name
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func asDomainType() -> User {
        return User(id: self.id,
                    name: self.name)
    }
}


