import Swinject

extension Container {
    static var `default` = Container()
}

class ServiceFacade {
    static let applicationService: ApplicationConfigurable = ApplicationConfiguration()
    static let persistentUserDefault: PersistentDataSaveable = UserDefaultsDataSaver()
    static let realmDataSaver: RealmDataSaverServiceable = RealmDataSaverServiceImplement()
    static func registerDefaultService(from windown: UIWindow) {
        ServiceFacade.initializeService(from: windown)
    }

    static func getService<T>(_ type: T.Type) -> T? {
        return Container.default.resolve(type)
    }

    static private func initializeService(from window: UIWindow) {
        applicationService.setup()
        Container.default.register(PersistentDataSaveable.self) { (_) -> PersistentDataSaveable in
            return ServiceFacade.persistentUserDefault
        }
    }

    static func shutDownAllService() {
        applicationService.shutDown()
    }
}
