import Cent

struct HandlerStack {
    private typealias EventType = String
    private typealias Key = String
    private var handlers = [EventType:[Key:[ObjectIdentifier:EventHandler]]]()
    
    init(_ handlers: [EventHandler] = []) {
        handlers.forEach{append($0)}
    }
    
    mutating func append(_ handler: EventHandler) {
        handlers[handler.eventType][handler.idOrType][handler.objectID] = handler
    }
    
    subscript(event: Event, from aggregateRoot: AggregateRoot) -> [EventHandler] {
        get {
            let dict =
                handlers[""][""] +
                handlers[event.type][""] +
                handlers[""][aggregateRoot.type] +
                handlers[event.type][event.id.description]
            
            return Array(dict.values)
        }
        
        set {
            handlers[""][""] = nil
            handlers[event.type][""] = nil
            handlers[""][aggregateRoot.type] = nil
            handlers[event.type][event.id.description] = nil
            
            newValue.forEach{append($0)}
        }
    }
}

func +<K: Hashable, V>(left: [K:V]?, right: [K:V]?) -> [K:V] {
    guard var left = left else { return right ?? [:] }
    guard let right = right else { return left }
    
    left.merge(dictionaries: right)
    
    return left
}
