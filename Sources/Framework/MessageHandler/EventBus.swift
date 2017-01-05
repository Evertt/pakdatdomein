public class FactBus {
    var handlers: [String:[FactHandlerMethod]]
    
    init(handlers: [FactHandler]) {
        var dict = [String:[FactHandlerMethod]]()
        
        for handler in handlers {
            for method in type(of: handler).handles {
                let key = method.factType
                dict[key].append(method)
            }
        }
        
        self.handlers = dict
    }
    
    func fire<E: Fact>(fact: E) {
        let key = "\(E.self)"
        
        guard let handlers = self.handlers[key] else {
            return
        }
        
        for handler in handlers {
            handler.handle(fact: fact)
        }
    }
}

protocol ArrayType: Collection, ExpressibleByArrayLiteral {
    mutating func append(_ newElement: Iterator.Element)
    mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element
}

extension Array: ArrayType {}

extension Optional where Wrapped: ArrayType {
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
