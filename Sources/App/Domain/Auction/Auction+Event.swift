extension Auction {
    enum Event {
        case auctionOpened(auctionID: ID, domainID: ID, start: Date, end: Date)
        case auctionCanceled
        case auctionCompleted
        case auctionExtended(newEndDate: Date)
        
        case bidAdded(bidID: ID, userID: ID, amount: Money)
        case bidCanceled(bidID: ID)
    }
}

extension Auction {
    static func apply(event: Event, to auction: Auction!) -> Auction {
        switch event {
            
        case let .auctionOpened(auctionID, domainID, start, end):
            return Auction(
                id: auctionID,
                domainID: domainID,
                bids: [:],
                start: start,
                end: end,
                status: .active
            )
            
        case .auctionCanceled:
            auction.status = .canceled
            
        case .auctionCompleted:
            auction.status = .completed
            
        case let .auctionExtended(newEndDate):
            auction.end = newEndDate
            
        case let .bidAdded(bidID, userID, amount):
            auction.bids[bidID] = Bid(id: bidID, userID: userID, amount: amount)

        case let .bidCanceled(bidID):
            auction.bids[bidID]!.canceled = true

        }
        
        return auction
    }
}
