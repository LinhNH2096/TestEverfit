import Foundation

enum DateFormat: String {
    var desc: String {
        return rawValue
    }

    // ISO
    case serverFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case isoShort = "yyyy-MM-dd'T'HH:mm:ssZ"
    case isoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    case dateHourMinuteSecond = "yyyy-MM-dd HH:mm:ss"
    case dateHourMinute = "yyyy-MM-dd HH:mm"
    case dateHourMinute2 = "yyyy/MM/dd HH:mm"
    case dateHourMinute3 = "HH:mm dd/MM/yyyy"
    case monthDayHourMinute = "MM/dd HH:mm"
    case date = "yyyy-MM-dd"
    case monthYear = "MM/yy"
    case yearMonth = "yyyy/MM"
    case hourMinute = "HH:mm"
    case dateExamination = "yyyy/MM/dd"
    case dateExamination2 = "yyyy/MM/dd (E)"
    case dateShort = "yyyy/M/dd"
    case monthDateYearDetail = "MMMM dd yyyy"
    case shortMonthDateYearDetail = "MMM dd yyyy"
    case monthYearDetail = "MMMM yyyy"
    case weekdayAndDateDetail = "EE, MMM d, yyyy"
}
