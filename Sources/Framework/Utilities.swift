protocol AnyArray: Collection, ExpressibleByArrayLiteral {
    mutating func append(_ newElement: Iterator.Element)
    mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element
}

extension Array: AnyArray {}

extension Optional where Wrapped: AnyArray {
    mutating func append(_ newElement: Wrapped.Iterator.Element) {
        switch self {
        case .none:
            var array: Wrapped = []
            array.append(newElement)
            self = .some(array)
            
        case .some(var array):
            array.append(newElement)
            self = .some(array)
        }
    }
    
    mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Wrapped.Iterator.Element {
        for newElement in newElements {
            append(newElement)
        }
    }
}

protocol AnyDictionary: ExpressibleByDictionaryLiteral {
    associatedtype Key
    associatedtype Value
    
    subscript(key: Key) -> Value? { get set }
}
extension Dictionary: AnyDictionary {}

extension Optional where Wrapped: AnyDictionary {
    subscript(key: Wrapped.Key) -> Wrapped.Value? {
        get {
            switch self {
            case .none: return nil
            case .some(let dict):
                return dict[key]
            }
        }
        
        set {
            switch self {
            case .none:
                var dict: Wrapped = [:]
                dict[key] = newValue
                self = dict
            case .some(var dict):
                dict[key] = newValue
                self = dict
            }
        }
    }
}

extension Dictionary where Key == ObjectIdentifier {
    subscript(key: Any) -> Value? {
        get {
            return self[ObjectIdentifier(type(of: key))]
        }
        set {
            self[ObjectIdentifier(type(of: key))] = newValue
        }
    }
    
    subscript(key: Any.Type) -> Value? {
        get {
            return self[ObjectIdentifier(key)]
        }
        set {
            self[ObjectIdentifier(key)] = newValue
        }
    }
}
