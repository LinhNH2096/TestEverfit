
import Foundation

struct User: RealmRepresentable {
    typealias RealmType = RMUser
    var id: String
    var name: String

    func asRealmType() -> RMUser {
        return RMUser(id: self.id, name: self.name)
    }
}
