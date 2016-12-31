protocol Fact {
    associatedtype Event

    var aggregateRootID : ID { get }
    var version         : Int { get }
    var event           : Event { get }
}

struct AnyFact<E>: Fact {
    typealias Event = E
    
    let aggregateRootID : ID
    let version         : Int
    let event           : Event
}

protocol Task {
    associatedtype Command

    var aggregateRootID : ID { get }
    var command         : Command { get }
}

struct AnyTask<C>: Task {
    typealias Command = C
    
    let aggregateRootID : ID
    let command         : Command
}
