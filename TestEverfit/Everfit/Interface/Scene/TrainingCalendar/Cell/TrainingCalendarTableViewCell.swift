import RxSwift
import RxCocoa

struct TrainingCalendarCellModel: Copyable {
    var date: Date
    var workouts: [WorkoutModel] = []
}

// MARK: TrainingCalendarTableViewCellDelegate
protocol TrainingCalendarTableViewCellDelegate: NSObjectProtocol {
    func didChangeSelection(cell: TrainingCalendarTableViewCell, with cellModel: TrainingCalendarCellModel)
}

// MARK: TrainingCalendarTableViewCell
class TrainingCalendarTableViewCell: UITableViewCell {
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var monthdayLabel: UILabel!
    @IBOutlet private weak var workoutStackView: UIStackView!

    private(set) var model: TrainingCalendarCellModel?
    weak var delegate: TrainingCalendarTableViewCellDelegate?

    func configureCell(with model: TrainingCalendarCellModel) {
        self.model = model
        weekdayLabel.text = model.date.weekDay.name
        weekdayLabel.textColor = model.date.isInToday ? AppColor.selected : AppColor.subText

        monthdayLabel.text = model.date.day.string
        monthdayLabel.textColor = model.date.isInToday ? AppColor.selected : AppColor.mainText
        workoutStackView.reset()
        model.workouts.forEach { workoutModel in
            let workoutView = WorkoutStatusView()
            workoutView.delegate = self
            workoutView.configureView(with: workoutModel)
            workoutStackView.addArrangedSubview(workoutView)
        }
    }

}

// MARK: WorkoutStatusViewDelegate
extension TrainingCalendarTableViewCell: WorkoutStatusViewDelegate {
    func didChangeSelection(workoutStatusView: WorkoutStatusView, with workoutModel: WorkoutModel) {
        guard var cellModel = self.model,
              let workoutIndex = cellModel.workouts.firstIndex(where: { $0.id == workoutModel.id })
        else { return }
        var newWorkouts = cellModel.workouts
        newWorkouts[workoutIndex] = workoutModel
        cellModel = cellModel.copy(withChanges: { $0.workouts = newWorkouts })
        self.delegate?.didChangeSelection(cell: self, with: cellModel)
    }
}
