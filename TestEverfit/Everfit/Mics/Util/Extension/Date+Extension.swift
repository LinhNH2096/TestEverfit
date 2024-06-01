import Foundation

extension Date {
    enum WeekDay: Int {
        case mon = 2, tue, wed, thu, fri, sat, sun // sunday = 8

        var name: String {
            switch self {
            case .mon:
                return "MON"
            case .tue:
                return "TUE"
            case .wed:
                return "WED"
            case .thu:
                return "THU"
            case .fri:
                return "FRI"
            case .sat:
                return "SAT"
            case .sun:
                return "SUN"
            }
        }
    }

    var weekDay: WeekDay {
        let rawWeekdaySystem = Calendar.current.component(.weekday, from: self)
        let rawWeekday = rawWeekdaySystem < 2 ? (rawWeekdaySystem + 7) : rawWeekdaySystem
        let weekday = WeekDay(rawValue: rawWeekday) ?? .mon
        return weekday
    }

    var startOfWeek: Date {
        let diffWithMonday: Int = WeekDay.mon.rawValue - self.weekDay.rawValue
        let startWeek = Calendar.current.date(byAdding: .day, value: diffWithMonday, to: self) ?? Date()
        return startWeek.startOfDate()
    }

    var endOfWeek: Date {
        let diffWithMonday: Int = WeekDay.sun.rawValue - self.weekDay.rawValue
        let endWeek = Calendar.current.date(byAdding: .day, value: diffWithMonday, to: self) ?? Date()
        return endWeek.startOfDate()
    }

    func getWeekdays() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        var currentDate = self.startOfWeek
        while currentDate <= self.endOfWeek {
            dates.append(currentDate)
            let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            currentDate = nextDay
        }
        return dates
    }

    func getMonthdays() -> [Date] {
        guard let startDate = self.getStartDateOfMonth(), let endDate = self.getEndDateOfMonth() else { return [] }
        var dates: [Date] = []
        let calendar = Calendar.current
        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            currentDate = nextDay
        }
        return dates
    }

    func dateToString(format: DateFormat,
                      locale: Locale = .current,
                      timeZone: TimeZone? = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format.desc
        let myDate = dateFormatter.string(from: self)
        return myDate
    }

    func localDateAsUTC() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else { return Date() }

        return localDate
    }

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    func getStartDateOfMonth() -> Date? {
        guard let interval = Calendar.current.dateInterval(of: .month, for: self) else {
            return nil
        }
        return interval.start
    }

    func getEndDateOfMonth() -> Date? {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: self) else {
            return nil
        }
        let endDate = calendar.date(byAdding: DateComponents(day: -1), to: interval.end)
        return endDate
    }

    func isSameDate(with date: Date?) -> Bool {
        guard let date else { return false }
        let startOfSelfDate = Calendar.current.startOfDay(for: self)
        let startOfDate = Calendar.current.startOfDay(for: date)
        return startOfSelfDate == startOfDate
    }

    func startOfDate() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}

