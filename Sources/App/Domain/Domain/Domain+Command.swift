extension Domain {
    enum Command {
        case putOnSale(price: Money)
        case cancelSale
        case completePurchase
        
        case openAuction
        case cancelAuction
        case completeAuction
        case extendAuction(newEndDate: Date)

        case addBid(bidID: ID, userID: ID, amount: Money)
        case cancelBid(bidID: ID)
    }
}

extension Domain: CommandHandler {
    static func handle(command: Command, for domain: Domain!) throws -> Domain {
        switch command {
        
        case let .putOnSale(price):
            return try domain.putOnSale(price: price)
        
        case .cancelSale:
            return try domain.cancelSale()
            
        case .completePurchase:
            return try domain.completePurchase()
            
        case .openAuction:
            return try domain.putOnAuction()
            
        case .cancelAuction:
            return try domain.cancelAuction()
            
        case .completeAuction:
            return try domain.completeAuction()
            
        case let .extendAuction(newEndDate):
            return try domain.extendAuction(to: newEndDate)
            
        case let .addBid(bidID, userID, amount):
            return try domain.addBid(bidID: bidID, userID: userID, amount: amount)
            
        case let .cancelBid(bidID):
            return try domain.cancelBid(bidID: bidID)

        }
    }
}
