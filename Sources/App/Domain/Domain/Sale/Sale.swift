final class Sale: AggregateRoot {
    let id                       : ID
    let domainID                 : ID
    let owner                    : Domain.Owner
    let price                    : Money
    var status                   : Status
    var activePurchaseRequest    : Purchase!
    var archivedPurchaseRequests : [ID:Purchase]

    var uncommittedEvents: [Event] = []

    init(
        id                       : ID,
        domainID                 : ID,
        owner                    : Domain.Owner,
        price                    : Money,
        status                   : Status = .active,
        activePurchaseRequest    : Purchase? = nil,
        archivedPurchaseRequests : [ID:Purchase] = [:]
    ) {
        self.id                       = id
        self.domainID                 = domainID
        self.owner                    = owner
        self.price                    = price
        self.status                   = status
        self.activePurchaseRequest    = activePurchaseRequest
        self.archivedPurchaseRequests = archivedPurchaseRequests
    }

    static func open(id: ID, domainID: ID, owner: Domain.Owner, price: Money) -> Sale {
        return apply(event: .saleOpened(saleID: id, domainID: domainID, owner: owner, price: price))
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
