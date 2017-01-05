extension Optional where Wrapped: AggregateRoot {
    func apply(_ fact: Fact, isNew: Bool = false) -> Wrapped {
        switch self {
        case .none:
            return Wrapped.apply(fact, isNew: isNew)
        case .some(let aggregateRoot):
            aggregateRoot.apply(fact, isNew: isNew)
            return aggregateRoot
        }
    }
    
    func handle(_ task: Task) throws -> Wrapped {
        switch self {
        case .none:
            return try Wrapped.handle(task)
        case .some(let aggregateRoot):
            try aggregateRoot.handle(task)
            return aggregateRoot
        }
    }
}

protocol _Optional {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: _Optional {
    var optional: Wrapped? {
        return self
    }
}

extension _Optional where Wrapped == AggregateRoot {
    func apply(_ fact: Fact, isNew: Bool = false, on arType: AggregateRoot.Type) -> AggregateRoot {
        switch optional {
        case .none:
            return arType.apply(fact, isNew: isNew)
        case .some(let aggregateRoot):
            aggregateRoot.apply(fact, isNew: isNew)
            return aggregateRoot
        }
    }
    
    func handle(_ task: Task, on arType: AggregateRoot.Type) throws -> AggregateRoot {
        switch optional {
        case .none:
            return try arType.handle(task)
        case .some(let aggregateRoot):
            try aggregateRoot.handle(task)
            return aggregateRoot
        }
    }
}
