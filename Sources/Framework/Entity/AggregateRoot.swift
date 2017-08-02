public protocol Entity: class, SaysType {
    var id: ID { get }
}

public protocol AggregateRoot: Entity {
    var version: Int { get set }
    var uncommittedEvents: [Event] { get set }
    
    static var applies: [String:EventApplier]   { get }
    static var handles: [String:CommandHandler] { get }
}

extension AggregateRoot {
    static func load(from history: [Event]?) -> Self? {
        return history?.reduce(nil) { $0.apply($1) }
    }
    
    @discardableResult
    func handle(_ command: Command) throws -> Self {
        guard let commandHandler = Self.handles[command.type] else {
            throw Error.noCommandHandlerFound(command: type(of: command))
        }
        
        return try commandHandler.handle(command: command, for: self)
    }
    
    static func handle(_ command: Command) throws -> Self {
        guard let commandHandler = handles[command.type] else {
            throw Error.noCommandHandlerFound(command: type(of: command))
        }
        
        return try commandHandler.handle(command: command, for: nil)
    }
    
    public func apply(_ event: Event) {
        apply(event, isNew: true)
    }
    
    public static func apply(_ event: Event) -> Self {
        return apply(event, isNew: true)
    }
    
    func apply(_ event: Event, isNew: Bool) {
        guard let eventApplier = Self.applies[event.type] else {
            print("No event applier found for \(type(of: event))")
            return
        }
        
        if isNew { uncommittedEvents.append(event) }
        eventApplier.apply(event: event, on: self)
    }
    
    static func apply(_ event: Event, isNew: Bool) -> Self {
        guard let eventApplier = applies[event.type] else {
            fatalError("No event applier found for \(type(of: event))")
        }
        
        let entity: Self = eventApplier.apply(event: event, on: nil)
        if isNew { entity.uncommittedEvents.append(event) }
        return entity
    }
}

enum Error: Swift.Error {
    case noCommandHandlerFound(command: Command.Type)
    case commandNotRightType(expected: Command.Type, got: Command.Type)
    case aggregateRootNotRightType(expected: AggregateRoot.Type, got: AggregateRoot.Type)
}
