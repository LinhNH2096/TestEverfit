import CoreData

class CoreDataManager {
    private init() {}
    static let shared = CoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiffusionDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    private var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - CRUD Operations
    func createEntity<T: NSManagedObject>(entityClass: T.Type) -> T? {
        let entityName = String(describing: entityClass)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            return nil
        }

        let entity = T(entity: entityDescription, insertInto: managedContext)
        return entity
    }

    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                fatalError("Failed to save managed context: \(error)")
            }
        }
    }

    func fetchEntities<T: NSManagedObject>(entityClass: T.Type,
                                           predicate: NSPredicate? = nil,
                                           sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let entityName = String(describing: entityClass)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            let entities = try managedContext.fetch(fetchRequest)
            return entities
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    func updateEntity<T: NSManagedObject>(_ entity: T) {
        saveContext()
    }

    func deleteEntity<T: NSManagedObject>(_ entity: T) {
        managedContext.delete(entity)
        saveContext()
    }

    func deleteEntitys<T: NSManagedObject>(_ entities: [T]) {
        entities.forEach { entity in
            managedContext.delete(entity)
        }
        saveContext()
    }
}
