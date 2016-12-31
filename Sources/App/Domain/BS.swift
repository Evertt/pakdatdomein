class AnyRepository<AR: AggregateRoot> {
    typealias Event = AR.Event
    var facts = [ID:[AnyFact<Event>]]()

    func getAggregateRoot(id: ID) -> AR? {
        return facts[id]?.reduce(nil) {
            aggregateRoot, fact in
            
            return AR.apply(event: fact.event, to: aggregateRoot)
        }
    }

    func save(_ aggregateRoot: AR) {
        let id     = aggregateRoot.id
        let facts  = self.facts[id] ?? []
        let events = aggregateRoot.uncommittedEvents

        self.facts[id] = events.reduce(facts) { facts, event in
            let version = (facts.last?.version ?? 0) + 1
            return facts + [AnyFact(aggregateRootID: id, version: version, event: event)]
        }
    }
}

// Will this be used anywhere?
// extension Optional where Wrapped: AggregateRoot {
//     func apply(event: Wrapped.Event) -> Wrapped {
//         switch self {
//         case .none:
//             return Wrapped.apply(event: event)
//         case .some(let aggregateRoot):
//             return Wrapped.apply(event: event, to: aggregateRoot)
//         }
//     }
// }
