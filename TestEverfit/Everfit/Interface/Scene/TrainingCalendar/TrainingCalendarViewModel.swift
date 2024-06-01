import RxSwift
import RxCocoa
import RealmSwift

class TrainingCalendarViewModel: BaseViewModel, ViewModelTransformable {

    // MARK: UseCase
    private var localDataUseCase: TrainingCalendarLocalDataUseCaseable = TrainingCalendarLocalDataUseCase()
    private var apiDataUseCase: TrainingCalendarAPIDataUseCaseable = TrainingCalendarAPIDataUseCase()

    // MARK: Subject
    private let dataModels = BehaviorRelay<[TrainingCalendarCellModel]>(value: [])
    private let localTrainingDayDatas = BehaviorRelay<[RMTrainingDayData]>(value: [])

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
        self.handleChangeWorkoutSelection(input: input)
        return Output(dataModels: dataModels.asDriverOnErrorJustComplete(),
                      onLoading: onLoading.asDriverOnErrorJustComplete(),
                      onError: onError.asDriverOnErrorJustComplete())
    }

    private func getCacheData() {
        self.localDataUseCase
            .getLocalTrainingData(startDate: currentDate.startOfWeek,
                                  endDate: currentDate.endOfWeek)
            .compactMap({ try? $0.get() })
            .bind(to: self.localTrainingDayDatas)
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
                    guard let self,
                          let response = response else { return }
                    let selectedAssignmentIds: [String] = self.localTrainingDayDatas.value
                        .map({ $0.getSelectedAssignmentIds() })
                        .reduce([], +)
                    let localData = response.dayData.map({ $0.asRealmType(selectedAssignmentIds: selectedAssignmentIds)
                    })
                    self.localTrainingDayDatas.accept(localData)
                case .failure(let error):
                    self?.onError.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleLocalTrainingData() {
        self.localTrainingDayDatas
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

        self.localTrainingDayDatas
            .flatMapLatest { [unowned self] data -> Driver<[Error]> in
                return self.localDataUseCase
                    .saveLocalTrainingDayData(data: data)
                    .asDriverOnErrorJustComplete()
            }
            .asDriverOnErrorJustComplete()
            .drive(onNext: { errors in
                print("[CACHE] - Errors \(errors)")
            })
            .disposed(by: disposeBag)
    }

    private func handleChangeWorkoutSelection(input: Input) {
        input.changedSelection
            .drive(onNext: { [weak self] workoutModel in
                self?.updateSelectionWith(workoutModel: workoutModel)
            })
            .disposed(by: disposeBag)
    }

    private func updateSelectionWith(workoutModel: WorkoutModel) {
        let localTrainingData = self.localTrainingDayDatas.value
        guard let localDayData = localTrainingData.first(where: { $0.date.isSameDate(with: workoutModel.date) }),
              let assignment = localDayData.assignments.first(where: { $0.id == workoutModel.id })
        else { return }
        do {
            let realm = try Realm()
            try realm.safeWrite({
                assignment.isSelected = workoutModel.isSelected
            })
            self.localTrainingDayDatas.accept(self.localTrainingDayDatas.value)
        } catch {
            print("[CACHE] Selection Error \(error.localizedDescription)")
        }
    }

}

extension TrainingCalendarViewModel {
    struct Input {
        var loadDataTrigger: Driver<Void>
        var changedSelection: Driver<WorkoutModel>
    }

    struct Output {
        var dataModels: Driver<[TrainingCalendarCellModel]>
        var onLoading: Driver<Bool>
        var onError: Driver<String>
    }
}
