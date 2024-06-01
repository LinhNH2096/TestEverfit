import UIKit

struct TrainingCalendarCellModel {
    var date: Date
    var workouts: [WorkoutModel]
}

class TrainingCalendarTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var monthdayLabel: UILabel!
    @IBOutlet private weak var workoutStackView: UIStackView!

    func configureCell(with model: TrainingCalendarCellModel) {
        weekdayLabel.text = model.date.weekDay.name
        weekdayLabel.textColor = model.date.isInToday ? AppColor.selected : AppColor.subText

        monthdayLabel.text = model.date.day.string
        monthdayLabel.textColor = model.date.isInToday ? AppColor.selected : AppColor.mainText
        workoutStackView.reset()
        model.workouts.forEach { workoutModel in
            let workoutView = WorkoutStatusView()
            workoutView.configureView(with: workoutModel)
            workoutStackView.addArrangedSubview(workoutView)
        }
    }

}
