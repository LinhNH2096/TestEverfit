import RxSwift
import RxCocoa

class TrainingCalendarViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Subjects
    private var trainingDates = BehaviorRelay<[TrainingCalendarCellModel]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.binding()
        self.bindingData()
    }

    private func setupUI() {
        tableView.register(nibWithCellClass: TrainingCalendarTableViewCell.self)
    }

    private func binding() {
        let cellIdentifier = TrainingCalendarTableViewCell.self.identifier
        trainingDates
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier,
                                       cellType: TrainingCalendarTableViewCell.self)) { index, model, cell in
                cell.configureCell(with: model)
        }
        .disposed(by: disposeBag)
    }

    private func bindingData() {
        let dayOfWeeks = Date().getWeekdays()
        let models: [TrainingCalendarCellModel] = dayOfWeeks.map { date in
            let workoutMissedModel = WorkoutModel(name: "Full warm up workout",
                                            status: .missed,
                                            numberOfExercises: 9,
                                            isEditable: date.isInToday)
            let workoutIdleModel = WorkoutModel(name: "Full warm up workout",
                                            status: .idle,
                                            numberOfExercises: 9,
                                            isEditable: date.isInToday)
            let workoutCompletedModel = WorkoutModel(name: "Full warm up workout",
                                            status: .completed,
                                            numberOfExercises: 9,
                                            isEditable: date.isInToday)
            let workoutFutureModel = WorkoutModel(name: "Full warm up workout",
                                            status: .future,
                                            numberOfExercises: 9,
                                            isEditable: date.isInToday)
            return TrainingCalendarCellModel(date: date, workouts: [])
        }
        trainingDates.accept(models)
    }
}
