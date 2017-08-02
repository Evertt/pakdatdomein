protocol EventHandler: class {
    var eventType: String { get }
    var idOrType: String { get }
    var objectID: ObjectIdentifier { get }
    
    func fire(event: Event, from type: AggregateRoot.Type) -> HandlerResponse?
}

enum HandlerResponse {
    case stopped
}

class AnyEventHandler<T: AnyObject>: EventHandler {
    typealias Handler = (T) -> (Event) -> ()
    
    weak var target : T?
    let handler     : Handler
    let type        : AggregateRoot.Type?
    let once        : Bool
    
    let eventType : String
    let idOrType  : String
    let objectID  : ObjectIdentifier
    
    init(target: T, handler: @escaping Handler, type: AggregateRoot.Type?, once: Bool) {
        self.target = target
        self.handler = handler
        self.type = type
        self.once = once
        
        eventType = ""
        idOrType  = type?.type ?? ""
        objectID  = ObjectIdentifier(target)
    }
    
    func fire(event: Event, from type: AggregateRoot.Type) -> HandlerResponse? {
        guard let target = self.target else { return .stopped }
        
        switch self.type.map({"\($0)"}) {
            
        case nil, "\(type)"?:
            handler(target)(event)
            if once { self.target = nil }
            return once ? .stopped : nil
            
        default: return nil
        }
    }
}

class SpecificEventHandler<T: AnyObject, E: Event>: EventHandler {
    typealias Handler = (T) -> (E) -> ()
    
    weak var target : T?
    let handler     : Handler
    let id          : ID?
    let once        : Bool
    
    let eventType : String
    let idOrType  : String
    let objectID  : ObjectIdentifier
    
    init(target: T, handler: @escaping Handler, id: ID?, once: Bool) {
        self.target = target
        self.handler = handler
        self.id = id
        self.once = once
        
        eventType = E.type
        idOrType  = id?.description ?? ""
        objectID  = ObjectIdentifier(target)
    }
    
    func fire(event: Event, from _: AggregateRoot.Type) -> HandlerResponse? {
        guard let target = self.target else { return .stopped }
        guard let event  = event as? E else { return nil      }
        
        switch id {
            
        case nil, event.id?:
            handler(target)(event)
            if once { self.target = nil }
            return once ? .stopped : nil
            
        default: return nil
        }
    }
}
