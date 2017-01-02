extension Sale {
    enum Command {
        case open(saleID: ID, domainID: ID, price: Money)
        case cancel
        case complete
    }
}

extension Sale: CommandHandler {
    static func handle(command: Command, for sale: Sale!) throws -> Sale {
        switch command {

        case let .open(saleID, domainID, price):
            return Sale.open(id: saleID, domainID: domainID, price: price)

        case .cancel:
            return try sale.cancel()

        case .complete:
            return try sale.complete()

        }
    }
}
