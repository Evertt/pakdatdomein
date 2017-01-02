extension Auction {
    enum Command {
        case openAuction(auctionID: ID, domainID: ID)
        case cancelAuction
        case completeAuction
        case extendAuction(newEndDate: Date)
        
        case addBid(bidID: ID, userID: ID, amount: Money)
        case cancelBid(bidID: ID)
    }
}

extension Auction: CommandHandler {
    static func handle(command: Command, for auction: Auction!) throws -> Auction {
        switch command {
        
        case let .openAuction(auctionID, domainID):
            return Auction.open(auctionID: auctionID, domainID: domainID)

        case .cancelAuction:
            return try auction.cancel()
            
        case .completeAuction:
            return try auction.complete()
            
        case let .extendAuction(newEndDate):
            return try auction.extend(to: newEndDate)
            
        case let .addBid(bidID, userID, amount):
            return try auction.addBid(bidID: bidID, userID: userID, amount: amount)

        case let .cancelBid(bidID):
            return try auction.cancelBid(bidID: bidID)

        }
    }
}
