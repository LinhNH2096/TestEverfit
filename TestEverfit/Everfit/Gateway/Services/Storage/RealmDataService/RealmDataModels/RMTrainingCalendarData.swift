import RealmSwift

// MARK: - RMTrainingDayData
class RMTrainingDayData: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var trainer: String = UUID().uuidString
    @objc dynamic var client: String = UUID().uuidString
    @objc dynamic var day: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    var assignments = List<RMAssignment>()

    convenience init(id: String = "",
                     trainer: String = "",
                     client: String = "",
                     day: String = "",
                     date: Date = Date(),
                     assignments: List<RMAssignment> = List<RMAssignment>()) {
        self.init()
        self.id = id
        self.trainer = trainer
        self.client = client
        self.day = day
        self.date = date
        self.assignments = assignments
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func toTrainingCalendarCellModel() -> TrainingCalendarCellModel {
        let workouts: [WorkoutModel] = assignments.map { assignment -> WorkoutModel in
            if self.date.isInFuture {
                return WorkoutModel(id: assignment.id,
                                    date: self.date,
                                    name: assignment.title,
                                    status: .future,
                                    numberOfExercises: assignment.exercisesCount,
                                    completedExercises: assignment.exercisesCompleted)
            } else if self.date.isInToday {
                let status: WorkoutStatus = assignment.isCompleted ? .completed : .idle
                return WorkoutModel(id: assignment.id,
                                    date: self.date,
                                    name: assignment.title,
                                    status: status,
                                    numberOfExercises: assignment.exercisesCount,
                                    completedExercises: assignment.exercisesCompleted)
            } else {
                let status: WorkoutStatus = assignment.isCompleted ? .completed : .missed
                return WorkoutModel(id: assignment.id,
                                    date: self.date,
                                    name: assignment.title,
                                    status: status,
                                    numberOfExercises: assignment.exercisesCount,
                                    completedExercises: assignment.exercisesCompleted)
            }
        }
        return TrainingCalendarCellModel(date: date,
                                         workouts: workouts)
    }
}

// MARK: - RMAssignment
class RMAssignment: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var status: Int = 0
    @objc dynamic var client: String = UUID().uuidString
    @objc dynamic var title: String = UUID().uuidString
    @objc dynamic var day: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var exercisesCompleted: Int = 0
    @objc dynamic var exercisesCount: Int = 0
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var duration: Int = 0
    @objc dynamic var rating: Int = 0

    var isCompleted: Bool {
        return exercisesCompleted == exercisesCount
    }

    convenience init(id: String = UUID().uuidString,
                     status: Int = 0,
                     client: String = UUID().uuidString,
                     title: String = UUID().uuidString,
                     day: String = UUID().uuidString,
                     date: Date = Date(),
                     exercisesCompleted: Int = 0,
                     exercisesCount: Int = 0,
                     startDate: Date = Date(),
                     endDate: Date = Date(),
                     duration: Int = 0,
                     rating: Int = 0) {
        self.init()
        self.id = id
        self.status = status
        self.client = client
        self.title = title
        self.day = day
        self.date = date
        self.exercisesCompleted = exercisesCompleted
        self.exercisesCount = exercisesCount
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.rating = rating
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
