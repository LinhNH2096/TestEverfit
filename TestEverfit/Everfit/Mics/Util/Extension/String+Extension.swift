import Foundation

extension String {
    func iso8601StringToDate() -> Date? {
        return Date(iso8601String: self)
    }
}
