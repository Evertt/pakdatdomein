public protocol Repository {
    func get(_ arType: AggregateRoot.Type) -> [AggregateRoot]
    func get(_ arType: AggregateRoot.Type, byID id: ID) -> AggregateRoot?
    func getEvents(from arType: AggregateRoot.Type, with id: ID) -> [Event]
    func getEvents(startingAt index: Int, max: Int) -> [Event]
    func save(_ aggregateRoot: AggregateRoot)
}

public class ARepository: Repository {
    public typealias ARType  = String
    public typealias Version = Int
    public typealias Index   = Int

    var events  = [Event]()
    var indices = [ObjectIdentifier:[ID:[Version:Index]]]()
    
    public init() {}
    
    public func get(_ arType: AggregateRoot.Type) -> [AggregateRoot] {
        return getEvents(from: arType).compactMap(arType.load)
    }
    
    public func getEvents(from arType: AggregateRoot.Type) -> [[Event]] {
        let keys = self.indices[arType]?.map { $0.key } ?? []
        
        return keys.map { getEvents(from: arType, with: $0) }
    }

    public func get(_ aggregateRoot: AggregateRoot.Type, byID id: ID) -> AggregateRoot? {
        return aggregateRoot.load(from: getEvents(from: aggregateRoot, with: id))
    }
    
    public func getEvents(from arType: AggregateRoot.Type, with id: ID) -> [Event] {
        let indices = self.indices[arType][id]?.sorted{ $0.key < $1.key }.map{$1}
        
        return (indices ?? []).map { events[$0] }
    }
    
    public func getEvents(startingAt index: Index = 0, max: Int = Int.max) -> [Event] {
        let maxIndex = Swift.min(index + max, events.endIndex)
        return Array(events[0..<maxIndex])
    }

    public func save(_ aggregateRoot: AggregateRoot) {
        let events = aggregateRoot.uncommittedEvents
        
        for event in events {
            indices[aggregateRoot][aggregateRoot.id][event.version] = self.events.count
            self.events.append(event)
        }
    }
}
