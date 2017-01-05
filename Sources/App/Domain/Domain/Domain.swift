final class Domain: AggregateRoot {
    let id       : ID
    let url      : URL
    var owner    : Owner!
    var business : Business!

    var uncommittedEvents = [Event]()
    
    init(id: ID, url: URL, owner: Owner?) {
        self.id    = id
        self.url   = url
        self.owner = owner
    }
    
    func putOnSale(price: Money) throws -> Domain {
        try ensure(.noBusinessIsActive)
        
        return apply(event: .saleOpened(owner: owner, price: price))
    }
    
    func requestPurchase(userID: ID) throws -> Domain {
        try ensure(.saleIsRunning)
        try ensure(.noPendingPurchase)
        
        return apply(event: .purchaseRequested(userID: userID))
    }
    
    func cancelPurchase() throws -> Domain {
        try ensure(.purchaseIsPending)
        
        return apply(event: .purchaseCanceled)
    }
    
    func completePurchase() throws -> Domain {
        try ensure(.purchaseIsPending)

        let userID = business.sale.purchase.userID
        let newOwner = Owner.user(userID: userID)

        apply(event: .purchaseCompleted)
        apply(event: .domainChangedOwner(newOwner: newOwner))

        return self
    }
    
    func cancelSale() throws -> Domain {
        try ensure(.saleIsRunning)
        
        if check(.purchaseIsPending) {
            apply(event: .purchaseCanceled)
        }
        
        return apply(event: .saleCanceled)
    }
    
    func putOnAuction() throws -> Domain {
        try ensure(.noBusinessIsActive)
        
        return apply(event: .auctionOpened(
            owner: owner,
            start: .now,
            end: .now + Default.durationOfAuction
        ))
    }
    
    func addBid(bidID: ID, userID: ID, amount: Money) throws -> Domain {
        try ensure(.auctionIsRunning)
        
        apply(event: .bidAdded(bidID: bidID, userID: userID, amount: amount))
        
        if business.auction.end < .now + 1.hour {
            let newDate: Date = .now + 1.hour
            
            apply(event: .auctionExtended(newEndDate: newDate))
        }
        
        return self
    }
    
    func cancelBid(bidID: ID) throws -> Domain {
        try ensure(.bidIsActive(bidID))
        
        return apply(event: .bidCanceled(bidID: bidID))
    }
    
    func completeAuction() throws -> Domain {
        try ensure(.auctionIsRunning)

        let bid: Bid? = business.auction.bids.reduce(nil) {
            result, item in
            
            guard let amount = result?.amount else {
                return item.value
            }
            
            if item.value.amount > amount {
                return item.value
            }
            
            return result
        }

        apply(event: .auctionCompleted)
        
        if let bid = bid {
            let newOwner = Owner.user(userID: bid.userID)
            apply(event: .domainChangedOwner(newOwner: newOwner))
        }
        
        return self
    }
    
    func cancelAuction() throws -> Domain {
        try ensure(.auctionIsRunning)
        
        return apply(event: .auctionCanceled)
    }
    
    func extendAuction(to newDate: Date) throws -> Domain {
        try ensure(.auctionIsRunning)
        
        return apply(event: .auctionExtended(newEndDate: newDate))
    }
}
