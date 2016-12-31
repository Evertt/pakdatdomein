protocol Aggregate: Hashable {
    var id: ID { get }
}

extension Aggregate {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(left: Self, right: Self) -> Bool {
        return left.id == right.id
    }
}

protocol AggregateRoot: class, Aggregate {
    associatedtype Event

    var uncommittedEvents: [Event] { get set }

    static func apply(event: Event, to aggregateRoot: Self!) -> Self
}

protocol CommandHandler {
    associatedtype AR: AggregateRoot
    associatedtype Command

    static func handle(command: Command, for aggregateRoot: AR!) throws -> [AR.Event]
}

extension AggregateRoot {

    @discardableResult
    func apply(event: Event) -> Self {
        return Self.apply(event: event, to: self)
    }
    
    @discardableResult
    func fire(event: Event) -> Self {
        return Self.fire(event: event, from: self)
    }
    
    static func apply(event: Event) -> Self {
        return apply(event: event, to: nil)
    }
    
    static func fire(event: Event) -> Self {
        return fire(event: event, from: nil)
    }
    
    static func fire(event: Event, from aggregateRoot: Self?) -> Self {
        let aggregateRoot = apply(event: event, to: aggregateRoot)
        aggregateRoot.uncommittedEvents.append(event)
        return aggregateRoot
    }

}
