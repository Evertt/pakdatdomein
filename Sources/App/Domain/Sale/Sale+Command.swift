extension Sale {
    enum Command {
        case open(saleID: ID, domainID: ID, price: Money)
        case cancel
        case complete
    }
}

extension Sale: CommandHandler {
    static func handle(command: Command, for sale: Sale!) throws -> [Event] {
        switch command {

        case let .open(saleID, domainID, price):
            let sale = Sale.open(id: saleID, domainID: domainID, price: price)
            return sale.uncommittedEvents

        case .cancel:
            try sale.cancel()

        case .complete:
            try sale.complete()

        }

        return sale.uncommittedEvents
    }
}
