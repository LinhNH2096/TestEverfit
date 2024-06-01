import RxSwift
import RxCocoa

enum WorkoutStatus {
    case idle
    case completed
    case missed
    case future
}

struct WorkoutModel: Copyable {
    let id: String
    let date: Date
    var name: String
    var status: WorkoutStatus
    var numberOfExercises: Int
    var completedExercises: Int
    var isSelected: Bool = false

    var missedExercises: Int {
        return numberOfExercises - completedExercises
    }

    var statusAttributeText: NSAttributedString {
        let font: UIFont = AppFont.openSans(size: 13)
        let normalExercisesAttribute = [NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: AppColor.mainText]

        let futureExercisesAttribute = [NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: AppColor.subText]

        let completedAttribute = [NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: AppColor.whiteText]

        let missedAttribute = [NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: AppColor.missedText]

        let result = NSMutableAttributedString(string: "", attributes: [:])
        switch status {
        case .idle:
            result.append(NSAttributedString(string: String(numberOfExercises) + " exercises", attributes: normalExercisesAttribute))
        case .future:
            result.append(NSAttributedString(string: String(numberOfExercises) + " exercises", attributes: futureExercisesAttribute))
        case .completed:
            result.append(NSAttributedString(string: "Completed", attributes: completedAttribute))
        case .missed:
            result.append(NSAttributedString(string: "Missed ", attributes: missedAttribute))
            result.append(NSAttributedString(string: "• \(String(missedExercises)) exercises ", attributes: normalExercisesAttribute))
        }
        return result
    }
}

// MARK: WorkoutStatusViewDelegate
protocol WorkoutStatusViewDelegate: NSObjectProtocol {
    func didChangeSelection(workoutStatusView: WorkoutStatusView, with workoutModel: WorkoutModel)
}

// MARK: WorkoutStatusView
class WorkoutStatusView: BaseView {
    // MARK: Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var filledImageView: UIImageView!

    // MARK: Variables
    private(set) var model: WorkoutModel?
    weak var delegate: WorkoutStatusViewDelegate?

    override func nibSetup() {
        super.nibSetup()
    }

    func configureView(with model: WorkoutModel) {
        self.model = model
        containerView.backgroundColor = model.status == .completed ? AppColor.selected : AppColor.normalBackground
        filledImageView.isHidden = !model.isSelected
        statusLabel.attributedText = model.statusAttributeText
        titleLabel.text = model.name
        switch model.status {
        case .idle, .missed:
            titleLabel.textColor = AppColor.mainText
        case .completed:
            titleLabel.textColor = AppColor.whiteText
        case .future:
            titleLabel.textColor = AppColor.subText
        }
    }

    @IBAction private func didChangeSelection(sender: UIControl) {
        guard var workoutModel = self.model else { return }
        workoutModel = workoutModel.copy(withChanges: { $0.isSelected = !$0.isSelected })
        self.delegate?.didChangeSelection(workoutStatusView: self, with: workoutModel)
    }
}
