import Foundation

protocol Copyable {
    func copy(withChanges changes: (inout Self) -> Void) -> Self
}

extension Copyable {
    func copy(withChanges changes: (inout Self) -> Void) -> Self {
        var copiedInstance = self
        changes(&copiedInstance)
        return copiedInstance
    }
}
