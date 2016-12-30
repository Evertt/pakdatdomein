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

protocol AggregateRoot: Aggregate {
    associatedtype Event
    var uncommittedEvents: [Event] { get }
    static func apply(event: Event, to entity: Self!) -> Self
}

extension AggregateRoot {
    var uncommittedEvents: [Event] {
        return []
    }

    @discardableResult
    static func apply(event: Event) -> Self {
        return apply(event: event, to: nil)
    }

    func apply(event: Event) {
        
    }
}