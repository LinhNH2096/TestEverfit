import UIKit

enum WorkoutStatus {
    case idle
    case completed
    case missed
    case future
}

struct WorkoutModel {
    var name: String
    var status: WorkoutStatus
    var numberOfExercises: Int = 0
    var isEditable: Bool

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
            result.append(NSAttributedString(string: "• \(String(numberOfExercises)) exercises ", attributes: normalExercisesAttribute))
        }
        return result
    }
}

class WorkoutStatusView: BaseView {
    // MARK: Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var filledImageView: UIImageView!
    @IBOutlet private weak var actionButton: UIButton!

    override func nibSetup() {
        super.nibSetup()
    }

    func configureView(with model: WorkoutModel) {
        actionButton.isHidden = !model.isEditable
        containerView.backgroundColor = model.status == .completed ? AppColor.selected : AppColor.normalBackground

        filledImageView.isHidden = model.status != .completed
        statusLabel.attributedText = model.statusAttributeText

        switch model.status {
        case .idle, .missed:
            titleLabel.textColor = AppColor.mainText
        case .completed:
            titleLabel.textColor = AppColor.whiteText
        case .future:
            titleLabel.textColor = AppColor.subText
        }
    }
}
