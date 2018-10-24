public protocol Bus {
    func send(_ command: Command) throws
    func subscribe<E: Event>(_ handler: @escaping (E) throws -> (), to id: ID?)
    func subscribeOnce<E: Event>(_ handler: @escaping (E) throws -> (), to id: ID?)
    func removeSubscription<E: Event>(_ handler: (E) throws -> (), from id: ID?)
}

public extension Bus {
    func subscribe<E: Event>(_ handler: @escaping (E) throws -> ()) {
        subscribe(handler, to: nil)
    }
    
    func subscribeOnce<E: Event>(_ handler: @escaping (E) throws -> ()) {
        subscribeOnce(handler, to: nil)
    }
    
    func removeSubscription<E: Event>(_ handler: (E) throws -> ()) {
        removeSubscription(handler, from: nil)
    }
}

struct Handler {
    let fire: (Event) throws -> ()
    let id: ID?
    let once: Bool
    
//    static func key<E>(type: E.Type, id: ID? = nil) -> String where E: Event {
//        return String(describing: (type, id))
//    }
    
    static func key(type: Event.Type, id: ID? = nil) -> String {
        return String(describing: (type, id))
    }
    
    init<E>(_ handler: @escaping (E) throws -> (), to id: ID?, once: Bool = false) where E : Event {
        fire = {
            if let event = $0 as? E {
                try handler(event)
            }
        }
        
        self.id = id
        self.once = once
    }
}

class EBus: Bus {
    let commandBus: CommandBus
    var handlers = [String:Handler]()

    init(commandBus: CommandBus, sagas: [Saga.Type]) {
        self.commandBus = commandBus
        sagas.forEach { $0.init(bus: self) }
    }
    
    func send(_ command: Command) throws {
        try commandBus.send(command)
    }
    
    func subscribe<E>(_ handler: @escaping (E) throws -> (), to id: ID?) where E : Event {
        handlers[Handler.key(type: E.self, id: id)] = Handler(handler, to: id)
    }
    
    func subscribeOnce<E>(_ handler: @escaping (E) throws -> (), to id: ID?) where E : Event {
        handlers[Handler.key(type: E.self, id: id)] = Handler(handler, to: id, once: true)
    }
    
    func removeSubscription<E>(_ handler: (E) throws -> (), from id: ID?) where E : Event {
        handlers.removeValue(forKey: Handler.key(type: E.self, id: id))
    }
    
    func fireEvents(of aggregateRoot: AggregateRoot) throws {
        for event in aggregateRoot.uncommittedEvents {
            let generalKey  = Handler.key(type: type(of: event), id: nil)
            let specificKey = Handler.key(type: type(of: event), id: aggregateRoot.id)
            
            try fire(event, for: generalKey)
            try fire(event, for: specificKey)
        }
    }
    
    func fire(_ event: Event, for key: String) throws {
        let handler = handlers[key]
        
        try handler?.fire(event)
        
        if handler?.once == true {
            handlers.removeValue(forKey: key)
        }
    }
}

public protocol Saga {
    @discardableResult
    init(bus: Bus)
}
