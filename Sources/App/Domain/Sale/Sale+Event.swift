extension Sale {
    enum Event {
        case saleOpened(saleID: ID, domainID: ID, price: Money)
        case saleCanceled
        case saleCompleted
    }
}

extension Sale {
    static func apply(event: Event, to sale: Sale!) -> Sale {
        switch event {

        case let .saleOpened(saleID, domainID, price):
            return Sale(id: saleID, domainID: domainID, price: price)

        case .saleCanceled:
            sale.status = .canceled

        case .saleCompleted:
            sale.status = .completed

        }

        return sale
    }
}
