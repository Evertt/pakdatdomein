public protocol FactApplier {
    var type: Any.Type { get }
    
    @discardableResult
    func apply<AR: AggregateRoot>(fact: Fact, on aggregateRoot: AR?) -> AR
}

struct TypeFactApplier<AR: AggregateRoot, E: Fact>: FactApplier {
    typealias Applier = (E) -> AR
    let applier: Applier
    let type: Any.Type
    
    init(applier: @escaping Applier) {
        self.applier = applier
        self.type = E.self
    }
    
    func apply<T: AggregateRoot>(fact: Fact, on _: T?) -> T {
        return applier(fact as! E) as! T
    }
}

struct InstanceFactApplier<AR: AggregateRoot, E: Fact>: FactApplier {
    typealias Applier = (AR) -> (E) -> Void
    let applier: Applier
    let type: Any.Type
    
    init(applier: @escaping Applier) {
        self.applier = applier
        self.type = E.self
    }
    
    func apply<T: AggregateRoot>(fact: Fact, on aggregateRoot: T?) -> T {
        let fact = fact as! E
        let aggregateRoot = aggregateRoot as! AR
        
        applier(aggregateRoot)(fact)
        
        return aggregateRoot as! T
    }
}
