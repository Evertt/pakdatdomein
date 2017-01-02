// This is currently not being used,
// but it might come in handy someday?

extension Optional where Wrapped: AggregateRoot {
    mutating func apply(event: Wrapped.Event) {
        self = applying(event: event)
    }

    func applying(event: Wrapped.Event) -> Wrapped {
        switch self {
        case .none:
            return Wrapped.apply(event: event)
        case .some(let aggregateRoot):
            return Wrapped.apply(event: event, to: aggregateRoot)
        }
    }
}