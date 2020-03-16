// sourcery:begin: commands
extension Domain {
    public static func createFoundDomain(id: ID, url: URL) -> Domain {
        return apply(DomainFound(id: id, version: 1, url: url))
    }
    
    public func grabDomain() {
        apply(DomainGrabbed(id: id, version: version))
    }

    public func putOnSale(price: Money) throws {
        try ensure(.noBusinessIsActive)
        
        apply(SaleOpened(id: id, version: version, owner: owner, price: price))
    }

    public func requestPurchase(userID: ID) throws {
        try ensure(.saleIsRunning, .noPendingPurchase, .buyerIsNotOwner(userID))
        
        apply(PurchaseRequested(id: id, version: version, userID: userID))
    }

    public func cancelPurchase() throws {
        try ensure(.purchaseIsPending)
        
        apply(PurchaseCanceled(id: id, version: version))
    }

    public func cancelSale() throws {
        try ensure(.saleIsRunning)
        
        if check(.purchaseIsPending) {
            apply(PurchaseCanceled(id: id, version: version))
        }
        
        apply(SaleCanceled(id: id, version: version))
    }

    public func completePurchase() throws {
        try ensure(.purchaseIsPending)

        let userID   = sale.purchase!.userID
        let newOwner = Owner.user(userID: userID)

        apply(PurchaseCompleted(id: id, version: version))
        apply(DomainChangedOwner(id: id, version: version, newOwner: newOwner))
    }

    public func openAuction() throws {
        try ensure(.noBusinessIsActive)
        
        apply(AuctionOpened(
            id      : id,
            version : version,
            owner   : owner ?? .us,
            start   : .now,
            end     : .now + Default.durationOfAuction
        ))
    }

    public func cancelAuction() throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionCanceled(id: id, version: version))
    }

    public func completeAuction() throws {
        try ensure(.auctionIsRunning)
        
        let winningBid = auction.bids.values
            .filter { !$0.canceled }
            .max { $0.amount < $1.amount }

        apply(AuctionCompleted(id: id, version: version))

        if let winningBid = winningBid {
            let newOwner = Owner.user(userID: winningBid.userID)

            apply(DomainChangedOwner(id: id, version: version, newOwner: newOwner))
        }
    }

    public func extendAuction(newEndDate: Date) throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionExtended(id: id, version: version, newEndDate: newEndDate))
    }

    public func addBid(bidID: ID, userID: ID, amount: Money) throws {
        try ensure(.auctionIsRunning, .bidderIsNotOwner(userID))
        
        apply(BidAdded(
            id      : id,
            version : version, 
            bidID   : bidID,
            userID  : userID,
            amount  : amount
        ))
        
        if auction.end < .now + 1.hour {
            let newDate: Date = .now + 1.hour
            
            apply(AuctionExtended(id: id, version: version, newEndDate: newDate))
        }
    }

    public func cancelBid(bidID: ID) throws {
        try ensure(.bidIsActive(bidID))
        
        apply(BidCanceled(id: id, version: version, bidID: bidID))
    }
}
