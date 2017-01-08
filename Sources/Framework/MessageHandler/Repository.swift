public protocol Repository {
    func get(_ arType: AggregateRoot.Type, byID id: ID) -> AggregateRoot?
    func save(_ aggregateRoot: AggregateRoot)
}

public class ARepository: Repository {
    var events = [ID:[Event]]()
    
    public init() {}

    public func get(_ aggregateRoot: AggregateRoot.Type, byID id: ID) -> AggregateRoot? {
        return aggregateRoot.load(from: events[id])
    }
    
    public func getEvents(byID id: ID) -> [Event] {
        return events[id] ?? []
    }

    public func save(_ aggregateRoot: AggregateRoot) {
        let events = aggregateRoot.uncommittedEvents
        self.events[aggregateRoot.id].append(contentsOf: events)
    }
}

prefix operator ++

prefix func ++(x: inout Int) -> Int {
    x += 1
    return x
}
