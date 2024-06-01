import Foundation
import RxSwift
import RxCocoa
import RealmSwift

// MARK: - Serviceable
protocol RealmDataSaverServiceable: AnyObject {
    func addItemOrUpdateIfNeed<T: Object>(item: T)
    func deleteItem<T: Object>(item: T, id: Any)
    func getItem<T: Object>(itemType: T.Type, id: Any) -> T?
    func getAllItem<T: Object>(itemType: T.Type) -> [T]
    func getAllItem<T: Object>(itemType: T.Type, with predicate: NSPredicate) -> [T]
    func deleteAllItem<T: Object>(itemType: T.Type)
}

// MARK: - Service Implementation
class RealmDataSaverServiceImplement: RealmDataSaverServiceable {

    func addItemOrUpdateIfNeed<T>(item: T) where T: Object {
        do {
            let realm = try Realm()
            try realm.safeWrite({
                realm.add(item, update: .modified)
            })
        } catch {
            print("[REALM]: Failed to add object to Realm: \(error.localizedDescription)")
        }
    }

    func getItem<T>(itemType: T.Type, id: Any) -> T? where T: Object {
        do {
            let realm = try Realm()
            let item = realm.object(ofType: itemType, forPrimaryKey: id)
            if let item = item {
              return item
            }
            return nil
        } catch {
            print("[REALM]: Failed to get object from Realm: \(error.localizedDescription)")
            return nil
        }
    }

    func getAllItem<T>(itemType: T.Type) -> [T] where T: Object {
        do {
            let realm = try Realm()
            let listItems = realm.objects(T.self).toArray()
            return listItems
        } catch {
            print("[REALM]: Failed to get objects from Realm: \(error.localizedDescription)")
            return []
        }
    }

    func getAllItem<T>(itemType: T.Type, with predicate: NSPredicate) -> [T] where T: Object {
        do {
            let realm = try Realm()
            let listItems = realm.objects(T.self).filter(predicate).toArray()
            return listItems
        } catch {
            print("[REALM]: Failed to get objects from Realm: \(error.localizedDescription)")
            return []
        }
    }

    func deleteItem<T>(item: T, id: Any) where T: Object {
        do {
            let realm = try Realm()
            let itemCheckExisted = realm.object(ofType: T.self, forPrimaryKey: id)
            if let itemCheckExisted = itemCheckExisted {
                try realm.safeWrite {
                    realm.delete(itemCheckExisted)
                }
            } else {
                print("[REALM]: Failed to delete object from Realm")
            }
        } catch {
            print("[REALM]: Failed to delete object from Realm: \(error.localizedDescription)")
        }
    }

    func deleteAllItem<T>(itemType: T.Type) where T: Object {
        do {
            let realm = try Realm()
            realm.delete(realm.objects(T.self))
        } catch {
            print("[REALM]: Failed to delete objects from Realm: \(error.localizedDescription)")
        }
    }

}

extension Results {
    func toArray() -> [Element] {
        return self.map { $0 }
    }
}

extension RealmSwift.List {
    func toArray() -> [Element] {
        return self.map { $0 }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
