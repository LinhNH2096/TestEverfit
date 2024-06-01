import Foundation
import RxSwift
import RxCocoa
import RealmSwift

// MARK: - Serviceable
protocol RealmDataSaverServiceable: AnyObject {
    func addItemOrUpdateIfNeed<T: Object>(item: T) -> Result<T, Error>
    func getItem<T: Object>(itemType: T.Type, id: Any) -> Result<T?, Error>
    func getAllItem<T: Object>(itemType: T.Type) -> Result<[T], Error>
    func getAllItem<T: Object>(itemType: T.Type, with predicate: NSPredicate) -> Result<[T], Error>
    func deleteItem<T: Object>(item: T, id: Any) -> Result<T, Error>
    func deleteAllItem<T: Object>(itemType: T.Type) -> Result<Bool, Error>
}

// MARK: - Service Implementation
class RealmDataSaverServiceImplement: RealmDataSaverServiceable {

    func addItemOrUpdateIfNeed<T>(item: T) -> Result<T, Error> where T: Object  {
        do {
            let realm = try Realm()
            try realm.safeWrite({
                realm.add(item, update: .modified)
            })
            return .success(item)
        } catch {
            print("[REALM]: Failed to add object to Realm: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func getItem<T>(itemType: T.Type, id: Any) -> Result<T?, Error> where T: Object {
        do {
            let realm = try Realm()
            let item = realm.object(ofType: itemType, forPrimaryKey: id)
            if let item = item {
                return .success(item)
            }
            return .success(nil)
        } catch {
            print("[REALM]: Failed to get object from Realm: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func getAllItem<T>(itemType: T.Type) -> Result<[T], Error> where T: Object {
        do {
            let realm = try Realm()
            let listItems = realm.objects(T.self).toArray()
            return .success(listItems)
        } catch {
            print("[REALM]: Failed to get objects from Realm: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func getAllItem<T>(itemType: T.Type, with predicate: NSPredicate) -> Result<[T], Error> where T: Object {
        do {
            let realm = try Realm()
            let listItems = realm.objects(T.self).filter(predicate).toArray()
            return .success(listItems)
        } catch {
            print("[REALM]: Failed to get objects from Realm: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func deleteItem<T>(item: T, id: Any) -> Result<T, Error> where T: Object {
        do {
            let realm = try Realm()
            try realm.safeWrite {
                realm.delete(item)
            }
            return .success(item)
        } catch {
            print("[REALM]: Failed to delete object from Realm: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func deleteAllItem<T>(itemType: T.Type) -> Result<Bool, Error> where T: Object {
        do {
            let realm = try Realm()
            realm.delete(realm.objects(T.self))
            return .success(true)
        } catch {
            print("[REALM]: Failed to delete objects from Realm: \(error.localizedDescription)")
            return .failure(error)
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
