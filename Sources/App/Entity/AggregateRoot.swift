public protocol AggregateRoot: Entity {
    var version: Int { get set }
    var uncommittedEvents: [Event] { get set }
    
    static var handles: [String:TaskHandler]  { get }
    static var applies: [String:EventApplier] { get }
}

extension AggregateRoot {
    public static var handles: [String:TaskHandler]  { return [:] }
    public static var applies: [String:EventApplier] { return [:] }

    public static func load(from history: [Event]) -> Self? {
        return history.reduce(nil) { $0.apply($1) }
    }
    
    @discardableResult
    public func handle(_ task: Task) throws -> Self {
        return try Self.handles[task.type]!.handle(task: task, for: self)
    }
    
    public static func handle(_ task: Task) throws -> Self {
        return try handles[task.type]!.handle(task: task, for: nil)
    }
    
    public func apply(_ event: Event) {
        apply(event, isNew: true)
    }
    
    public static func apply(_ event: Event) -> Self {
        return apply(event, isNew: true)
    }
    
    func apply(_ event: Event, isNew: Bool) {
        if isNew { uncommittedEvents.append(event) }
        Self.applies[event.type]!.apply(event: event, on: self)
    }
    
    static func apply(_ event: Event, isNew: Bool) -> Self {
        let entity: Self = applies[event.type]!.apply(event: event, on: nil)
        if isNew { entity.uncommittedEvents.append(event) }
        return entity
    }
}
