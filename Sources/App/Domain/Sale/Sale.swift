final class Sale: AggregateRoot {
    let id       : ID
    let domainID : ID
    let price    : Money
    var status   : Status

    var uncommittedEvents: [Event] = []

    init(id: ID, domainID: ID, price: Money, status: Status = .active) {
        self.id       = id
        self.domainID = domainID
        self.price    = price
        self.status   = status
    }

    static func open(id: ID, domainID: ID, price: Money) -> Sale {
        return apply(event: .saleOpened(saleID: id, domainID: domainID, price: price))
    }

    func cancel() throws -> Sale {
        guard status == .active else {
            fatalError()
        }

        return apply(event: .saleCanceled)
    }

    func complete() throws -> Sale {
        guard status == .active else {
            fatalError()
        }

        return apply(event: .saleCompleted)
    }
}
