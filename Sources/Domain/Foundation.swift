@_exported import Timepiece
@_exported import Framework
@_exported import Foundation

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
    
    func max<T>(_ keyPath: KeyPath<Element, T>) -> Element? where T: Comparable {
        return self.max { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
    
    func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return filter { $0[keyPath: keyPath] }
    }
    
    func reject(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return filter { !$0[keyPath: keyPath] }
    }
}

extension Array: Error where Element: Error {}

extension Result {
    func getFailure() -> Failure? {
        if case .failure(let failure) = self {
            return failure
        }
        
        return nil
    }
}
