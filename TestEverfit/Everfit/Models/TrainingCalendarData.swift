import Foundation
import RealmSwift

// MARK: - TrainingCalendarResponse
struct TrainingCalendarResponse: Codable {
    let dayData: [TrainingDayData]

    enum CodingKeys: String, CodingKey {
        case dayData = "day_data"
    }
}

// MARK: - TrainingDayData
struct TrainingDayData: Codable, RealmRepresentable {
    typealias RealmType = RMTrainingDayData
    let id: String?
    let assignments: [Assignment]?
    let trainer, client, day, date: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case assignments, trainer, client, day, date
    }

    func asRealmType() -> RMTrainingDayData {
        let reamlAssignments: List<RMAssignment> = List<RMAssignment>()
        assignments?.compactMap({ $0})
            .forEach { assignment in
                reamlAssignments.append(assignment.asRealmType())
            }
        return RMTrainingDayData(id: id.unsafelyUnwrapped,
                                 trainer: trainer.unsafelyUnwrapped,
                                 client: client.unsafelyUnwrapped,
                                 day: day.unsafelyUnwrapped,
                                 date: (date?.iso8601StringToDate() ?? Date()).startOfDate(),
                                 assignments: reamlAssignments)
    }
}

// MARK: - Assignment
struct Assignment: Codable, RealmRepresentable {
    typealias RealmType = RMAssignment

    let id: String?
    let status: Int?
    let client, title, day, date: String?
    let exercisesCompleted, exercisesCount: Int?
    let startDate, endDate: String?
    let duration, rating: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, client, title, day, date
        case exercisesCompleted = "exercises_completed"
        case exercisesCount = "exercises_count"
        case startDate = "start_date"
        case endDate = "end_date"
        case duration, rating
    }

    func asRealmType() -> RMAssignment {
        return RMAssignment(id: id ?? "",
                            status: status ?? 0,
                            client: client ?? "",
                            title: title ?? "",
                            day: day ?? "",
                            date: (date?.iso8601StringToDate() ?? Date()).startOfDate(),
                            exercisesCompleted: exercisesCompleted ?? 0,
                            exercisesCount: exercisesCount ?? 0,
                            startDate: (startDate?.iso8601StringToDate() ?? Date()).startOfDate(),
                            endDate: (endDate?.iso8601StringToDate() ?? Date()).startOfDate(),
                            duration: duration ?? 0,
                            rating: rating ?? 0)
    }
}
