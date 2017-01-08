extension Optional where Wrapped: AggregateRoot {
    func apply(_ event: Event, isNew: Bool = false) -> Wrapped {
        switch self {
        case .none:
            return Wrapped.apply(event, isNew: isNew)
        case .some(let aggregateRoot):
            aggregateRoot.apply(event, isNew: isNew)
            return aggregateRoot
        }
    }
    
    func handle(_ command: Command) throws -> Wrapped {
        switch self {
        case .none:
            return try Wrapped.handle(command)
        case .some(let aggregateRoot):
            try aggregateRoot.handle(command)
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
    func apply(_ event: Event, isNew: Bool = false, on arType: AggregateRoot.Type) -> AggregateRoot {
        switch optional {
        case .none:
            return arType.apply(event, isNew: isNew)
        case .some(let aggregateRoot):
            aggregateRoot.apply(event, isNew: isNew)
            return aggregateRoot
        }
    }
    
    func handle(_ command: Command, on arType: AggregateRoot.Type) throws -> AggregateRoot {
        switch optional {
        case .none:
            return try arType.handle(command)
        case .some(let aggregateRoot):
            try aggregateRoot.handle(command)
            return aggregateRoot
        }
    }
}
