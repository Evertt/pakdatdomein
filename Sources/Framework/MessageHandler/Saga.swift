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

extension Handler {
    struct Key: Hashable {
        let eventType: ObjectIdentifier
        let id: ID?
        
        init(_ eventType: Event.Type, _ id: ID? = nil) {
            self.eventType = ObjectIdentifier(eventType)
            self.id = id
        }
        
        init(_ event: Event, _ id: ID? = nil) {
            self.init(type(of: event), id)
        }
    }
}

typealias Key = Handler.Key

class SagaEventBus: Bus {
    let commandBus: CommandBus
    var handlers = [Key:Handler]()

    init(commandBus: CommandBus, saga: Saga.Type) {
        self.commandBus = commandBus
        saga.init(bus: self)
    }
    
    func send(_ command: Command) throws {
        try commandBus.send(command)
    }
    
    func subscribe<E>(_ handler: @escaping (E) throws -> (), to id: ID?) where E : Event {
        handlers[Key(E.self, id)] = Handler(handler, to: id)
    }
    
    func subscribeOnce<E>(_ handler: @escaping (E) throws -> (), to id: ID?) where E : Event {
        handlers[Key(E.self, id)] = Handler(handler, to: id, once: true)
    }
    
    func removeSubscription<E>(_ handler: (E) throws -> (), from id: ID?) where E : Event {
        handlers.removeValue(forKey: Key(E.self, id))
    }
    
    func fireEvents(of aggregateRoot: AggregateRoot) throws {
        for event in aggregateRoot.uncommittedEvents {
            try fire(event, id: nil)
            try fire(event, id: aggregateRoot.id)
        }
    }
    
    func fire(_ event: Event, id: ID?) throws {
        let key = Key(event, id)
        
        guard let handler = handlers[key] else {
            return
        }
        
        try handler.fire(event)
        
        if handler.once {
            handlers.removeValue(forKey: key)
        }
    }
}

public protocol Saga {
    @discardableResult
    init(bus: Bus)
}
