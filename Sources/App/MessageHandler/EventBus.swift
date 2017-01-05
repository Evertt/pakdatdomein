public class EventBus {
    var handlers: [String:[EventHandlerMethod]]
    
    init(handlers: [EventHandler]) {
        var dict = [String:[EventHandlerMethod]]()
        
        for handler in handlers {
            for method in type(of: handler).handles {
                let key = method.eventType
                dict[key].append(method)
            }
        }
        
        self.handlers = dict
    }
    
    func fire<E: Event>(event: E) {
        let key = "\(E.self)"
        
        guard let handlers = self.handlers[key] else {
            return
        }
        
        for handler in handlers {
            handler.handle(event: event)
        }
    }
}

protocol ArrayType: Collection, ExpressibleByArrayLiteral {
    mutating func append(_ newElement: Iterator.Element)
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
}