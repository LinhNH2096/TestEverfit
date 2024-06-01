import RxCocoa
import RxSwift

protocol TrainingCalendarLocalDataUseCaseable {

    func getLocalTrainingData(startDate: Date, endDate: Date) -> Observable<Result<[RMTrainingDayData], Error>>

    func getAllLocalTrainingData() -> Observable<Result<[RMTrainingDayData], Error>>

    func saveLocalTrainingDayData(data trainingDayDatas: [RMTrainingDayData]) -> Observable<[Error]>
}

class TrainingCalendarLocalDataUseCase: TrainingCalendarLocalDataUseCaseable {
    var localDataService = ServiceFacade.realmDataSaver

    func getLocalTrainingData(startDate: Date, endDate: Date) -> Observable<Result<[RMTrainingDayData], any Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            let result = self.localDataService.getAllItem(itemType: RMTrainingDayData.self, with: predicate)
            observer.onNext(result)
            observer.on(.completed)
            return Disposables.create()
        })
    }

    func getAllLocalTrainingData() -> Observable<Result<[RMTrainingDayData], any Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            let result = self.localDataService.getAllItem(itemType: RMTrainingDayData.self)
            observer.onNext(result)
            observer.on(.completed)
            return Disposables.create()
        })
    }

    func saveLocalTrainingDayData(data trainingDayDatas: [RMTrainingDayData]) -> Observable<[Error]> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            var errors: [Error] = []
            trainingDayDatas.forEach { dayData in
                let result = self.localDataService.addItemOrUpdateIfNeed(item: dayData)
                switch result {
                case .success: break
                case .failure(let error):
                    errors.append(error)
                }
            }
            observer.onNext(errors)
            observer.on(.completed)
            return Disposables.create()
        })
    }
}
