import RxSwift
import RxCocoa

class TrainingCalendarViewController: BaseViewController {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Subjects
    private var loadDataTrigger = PublishRelay<Void>()
    private var changedSelection = PublishRelay<WorkoutModel>()
    private var trainingDates = BehaviorRelay<[TrainingCalendarCellModel]>(value: [])

    // MARK: Variables
    private var viewModel = TrainingCalendarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.bindingData()
        self.bindingUI()
    }

    private func setupUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(nibWithCellClass: TrainingCalendarTableViewCell.self)
    }

    private func bindingUI() {
        let cellIdentifier = TrainingCalendarTableViewCell.self.identifier
        trainingDates
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier,
                                       cellType: TrainingCalendarTableViewCell.self)) { [weak self] index, model, cell in
                guard let self else { return }
                cell.delegate = self
                cell.configureCell(with: model)
        }
        .disposed(by: disposeBag)

        loadDataTrigger.accept(())
    }

    private func bindingData() {
        let input = TrainingCalendarViewModel
            .Input(
                loadDataTrigger: loadDataTrigger.asDriverOnErrorJustComplete(),
                changedSelection: changedSelection.asDriverOnErrorJustComplete()
            )
        let output = viewModel.transform(input: input)

        output.onLoading
            .drive(rx.onLoading)
            .disposed(by: disposeBag)

        output.onError
            .drive(rx.onErrorMessage)
            .disposed(by: disposeBag)

        output.dataModels
            .drive(trainingDates)
            .disposed(by: disposeBag)
    }
}

// MARK: TrainingCalendarTableViewCellDelegate
extension TrainingCalendarViewController: TrainingCalendarTableViewCellDelegate {
    func didChangeSelection(cell: TrainingCalendarTableViewCell, with workoutModel: WorkoutModel) {
        self.changedSelection.accept(workoutModel)
    }
}
