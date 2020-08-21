// sourcery:begin: commands
extension Domain {
    public static func createFoundDomain(id: ID, url: URL) -> Domain {
        return apply(domainFound(id: id, url: url))
    }
    
    public func grabDomain() {
        apply(domainGrabbed())
    }

    public func putOnSale(price: Money) throws {
        try ensure(.noBusinessIsActive)
        
        apply(saleOpened(seller: owner ?? .us, price: price))
    }

    public func requestPurchase(userID: ID) throws {
        try ensure(
            .saleIsRunning,
            .noPurchaseIsPending,
            .buyerIsNotSeller(userID)
        )
        
        apply(purchaseRequested(userID: userID))
    }

    public func cancelPurchase() throws {
        try ensure(.purchaseIsPending)
        
        apply(purchaseCanceled())
    }

    public func cancelSale() throws {
        try ensure(.saleIsRunning)
        
        if check(.purchaseIsPending) {
            apply(purchaseCanceled())
        }
        
        apply(saleCanceled())
    }

    public func completePurchase() throws {
        try ensure(
            .purchaseIsPending,
            .domainIsOwnedByUsOrOurUser
        )

        let userID   = sale.purchase!.userID
        let newOwner = Owner.user(userID: userID)

        apply(purchaseCompleted())
        apply(domainChangedOwner(newOwner))
    }

    public func openAuction() throws {
        try ensure(.noBusinessIsActive)
        
        apply(auctionOpened(
            seller : owner ?? .us,
            start  : .now,
            end    : .now + Default.durationOfAuction
        ))
    }

    public func cancelAuction() throws {
        try ensure(.auctionIsRunning)
        
        apply(auctionCanceled())
    }

    public func completeAuction() throws {
        try ensure(
            .auctionIsRunning,
            .domainIsOwnedByUsOrOurUser
        )
        
        let winningBid = auction.bids
            .exclude(\.canceled).max(\.amount)

        apply(auctionCompleted())

        if let winningBid = winningBid {
            let newOwner = Owner.user(userID: winningBid.userID)

            apply(domainChangedOwner(newOwner))
        }
    }

    public func extendAuction(newEndDate: Date) throws {
        try ensure(.auctionIsRunning)
        
        apply(auctionExtended(newEndDate: newEndDate))
    }

    public func addBid(bidID: ID, userID: ID, amount: Money) throws {
        try ensure(.auctionIsRunning, .bidderIsNotSeller(userID))
        
        apply(bidAdded(bidID: bidID, userID: userID, amount: amount))
        
        if auction.end < 1.hour.fromNow {
            apply(auctionExtended(newEndDate: 1.hour.fromNow))
        }
    }

    public func cancelBid(bidID: ID) throws {
        try ensure(.bidIsActive(bidID))
        
        apply(bidCanceled(bidID))
    }
}
