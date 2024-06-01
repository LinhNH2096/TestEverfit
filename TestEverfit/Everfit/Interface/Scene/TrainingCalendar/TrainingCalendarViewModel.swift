import RxSwift
import RxCocoa


class TrainingCalendarViewModel: BaseViewModel, ViewModelTransformable {

    // MARK: UseCase
    private var localDataUseCase: TrainingCalendarLocalDataUseCaseable = TrainingCalendarLocalDataUseCase()
    private var apiDataUseCase: TrainingCalendarAPIDataUseCaseable = TrainingCalendarMockAPIDataUseCase()

    // MARK: Subject
    private let dataModels = BehaviorRelay<[TrainingCalendarCellModel]>(value: [])
    private let localTrainingData = BehaviorRelay<[RMTrainingDayData]>(value: [])

    private let onLoading = PublishRelay<Bool>()
    private let onError = PublishRelay<String>()

    // MARK: Variables
    private var currentDate: Date {
        return Date().startOfDate()
    }

    // MARK: Transform
    func transform(input: Input) -> Output {
        
        self.handleLocalTrainingData()
        self.getCacheData()
        self.handleLoadDataTrigger(input: input)

        return Output(dataModels: dataModels.asDriverOnErrorJustComplete(),
                      onLoading: onLoading.asDriverOnErrorJustComplete(),
                      onError: onError.asDriverOnErrorJustComplete())
    }

    private func getCacheData() {
        self.localDataUseCase
            .getLocalTrainingData(startDate: currentDate.startOfWeek,
                                  endDate: currentDate.endOfWeek)
            .compactMap({ try? $0.get() })
            .bind(to: self.localTrainingData)
            .disposed(by: disposeBag)
    }

    private func handleLoadDataTrigger(input: Input) {
        input.loadDataTrigger
            .flatMapLatest { [unowned self] _ -> Driver<Result<TrainingCalendarResponse?, Error>> in
                return self.apiDataUseCase
                    .getTrainingAPIData()
                    .asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    guard let response = response else { return }
                    let localData = response.dayData.map({ $0.asRealmType() })
                    self?.localTrainingData.accept(localData)
                case .failure(let error):
                    self?.onError.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleLocalTrainingData() {
        self.localTrainingData
            .map({ localData in
                let dataModels: [TrainingCalendarCellModel] = localData.map({ $0.toTrainingCalendarCellModel() })
                let weekDates: [Date] = self.currentDate.getWeekdays()
                let weekModels: [TrainingCalendarCellModel] = weekDates.map { date in
                    if let dataModel = dataModels.first(where: { $0.date.isSameDate(with: date) }) {
                        return TrainingCalendarCellModel(date: date, workouts: dataModel.workouts)
                    }
                    return TrainingCalendarCellModel(date: date)
                }

                return weekModels
            })
            .bind(to: self.dataModels)
            .disposed(by: disposeBag)

        self.localTrainingData
            .flatMapLatest { [unowned self] data -> Driver<[Error]> in
                return self.localDataUseCase.saveLocalTrainingDayData(data: data)
                    .asDriverOnErrorJustComplete()
            }
            .asDriverOnErrorJustComplete()
            .drive(onNext: { errors in
               print("[CACHE] - Errors \(errors)")
            })
            .disposed(by: disposeBag)
    }

}

extension TrainingCalendarViewModel {
    struct Input {
        var loadDataTrigger: Driver<Void>
    }

    struct Output {
        var dataModels: Driver<[TrainingCalendarCellModel]>
        var onLoading: Driver<Bool>
        var onError: Driver<String>
    }
}
