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
    static func handle(command: Command, for auction: Auction!) throws -> [Event] {
        switch command {
        
        case let .openAuction(auctionID, domainID):
            let auction = Auction.open(auctionID: auctionID, domainID: domainID)
            return auction.uncommittedEvents

        case .cancelAuction:
            try auction.cancel()
            
        case .completeAuction:
            try auction.complete()
            
        case let .extendAuction(newEndDate):
            try auction.extend(to: newEndDate)
            
        case let .addBid(bidID, userID, amount):
            try auction.addBid(bidID: bidID, userID: userID, amount: amount)

        case let .cancelBid(bidID):
            try auction.cancelBid(bidID: bidID)

        }
        
        return auction.uncommittedEvents
    }
}
