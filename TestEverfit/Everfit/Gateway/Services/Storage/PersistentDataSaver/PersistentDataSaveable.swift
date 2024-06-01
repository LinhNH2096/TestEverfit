import Foundation

// MARK: - Serviceable
protocol PersistentDataSaveable {
    func getItem(fromKey key: String) -> Any?
    func set(item: Any, toKey key: String)
}

// MARK: - Service Implement
class UserDefaultsDataSaver: PersistentDataSaveable {
    func getItem(fromKey key: String) -> Any? {
        do {
            if let dataSaved = UserDefaults.standard.object(forKey: key) as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataSaved)
            }
            return nil
        } catch {
             print("[UserDefaultsDataSaver]:\(error.localizedDescription)")
        }
        return nil
    }
    func set(item: Any, toKey key: String) {
        do {
            let dataArchive = try NSKeyedArchiver.archivedData(withRootObject: item,
                                                               requiringSecureCoding: true)
            UserDefaults.standard.set(dataArchive, forKey: key)
        } catch {
            print("[UserDefaultsDataSaver]:\(error.localizedDescription)")
        }
    }
}
