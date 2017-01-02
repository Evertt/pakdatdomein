protocol AggregateRoot: Aggregate {
    associatedtype Event: App.Event

    var uncommittedEvents: [Event] { get set }

    static func apply(event: Event, to aggregateRoot: Self!) -> Self
}

extension AggregateRoot {

    @discardableResult
    func apply(event: Event) -> Self {
        return Self.apply(event: event, to: self, saveEvents: true)
    }
    
    static func apply(event: Event) -> Self {
        return Self.apply(event: event, to: nil, saveEvents: true)
    }
    
    static func apply(event: Event, to aggregateRoot: Self?, saveEvents: Bool) -> Self {
        var aggregateRoot = apply(event: event, to: aggregateRoot)
        if saveEvents { aggregateRoot.uncommittedEvents.append(event) }
        return aggregateRoot
    }

}