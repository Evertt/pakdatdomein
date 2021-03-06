extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return self.map { $0[keyPath: keyPath] }
    }
    
    func max<T>(_ keyPath: KeyPath<Element, T>) -> Element? where T: Comparable {
        return self.max { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
    
    func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return self.filter { $0[keyPath: keyPath] }
    }
    
    func exclude(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return self.filter { !$0[keyPath: keyPath] }
    }
}

extension Dictionary {
    func map<T>(_ keyPath: KeyPath<Value, T>) -> [T] {
        return values.map(keyPath)
    }
    
    func max<T>(_ keyPath: KeyPath<Value, T>) -> Value? where T: Comparable {
        return values.max(keyPath)
    }
    
    func filter(_ keyPath: KeyPath<Value, Bool>) -> [Value] {
        return values.filter(keyPath)
    }
    
    func exclude(_ keyPath: KeyPath<Value, Bool>) -> [Value] {
        return values.exclude(keyPath)
    }
}
