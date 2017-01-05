public protocol EventApplier {
    var type: Any.Type { get }
    
    @discardableResult
    func apply<AR: AggregateRoot>(event: Event, on aggregateRoot: AR?) -> AR
}

struct TypeEventApplier<AR: AggregateRoot, E: Event>: EventApplier {
    typealias Applier = (E) -> AR
    let applier: Applier
    let type: Any.Type
    
    init(applier: @escaping Applier) {
        self.applier = applier
        self.type = E.self
    }
    
    func apply<T: AggregateRoot>(event: Event, on _: T?) -> T {
        return applier(event as! E) as! T
    }
}

struct InstanceEventApplier<AR: AggregateRoot, E: Event>: EventApplier {
    typealias Applier = (AR) -> (E) -> Void
    let applier: Applier
    let type: Any.Type
    
    init(applier: @escaping Applier) {
        self.applier = applier
        self.type = E.self
    }
    
    func apply<T: AggregateRoot>(event: Event, on aggregateRoot: T?) -> T {
        let event = event as! E
        let aggregateRoot = aggregateRoot as! AR
        
        applier(aggregateRoot)(event)
        
        return aggregateRoot as! T
    }
}