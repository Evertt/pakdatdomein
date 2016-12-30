protocol Fact {
    associatedtype Event

    var aggregateRootID: ID { get }
    var version: Int { get }
    var event: Event { get }
}

struct AnyFact<E> {
    typealias Event = E
    
    let aggregateRootID: ID
    let version: Int
    let event: Event
}

//protocol EventHandler {
//    associatedtype Event
//    associatedtype AggregateRoot
//
//    static func apply(event: Event, to: AggregateRoot!) -> AggregateRoot
//}
