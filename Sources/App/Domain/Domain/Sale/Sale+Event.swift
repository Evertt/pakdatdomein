extension Sale {
    enum Event {
        case saleOpened(saleID: ID, domainID: ID, owner: Domain.Owner, price: Money)
        case saleCanceled
        case saleCompleted

        case purchaseRequested(purchaseID: ID, userID: ID)
        case purchaseCompleted(purchaseID: ID)
    }
}

extension Sale {
    static func apply(event: Event, to sale: Sale!) -> Sale {
        switch event {

        case let .saleOpened(saleID, domainID, owner, price):
            return Sale(id: saleID, domainID: domainID, owner: owner, price: price)

        case .saleCanceled:
            sale.status = .canceled

        case .saleCompleted:
            sale.status = .completed

        case let .purchaseRequested(purchaseID, userID):
            sale.activePurchaseRequest = Purchase(
                id       : purchaseID,
                userID   : userID,
                domainID : sale.domainID,
                price    : sale.price,
                status   : .pending
            )

        case .purchaseCompleted:
            sale.activePurchaseRequest.status = .completed
        }

        return sale
    }
}
