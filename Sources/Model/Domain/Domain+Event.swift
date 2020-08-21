// sourcery:begin: events
extension Domain {
    static func domainFound(id: ID, url: URL) -> Domain {
        return Domain(
            id    : id,
            url   : url,
            owner : nil
        )
    }

    static func domainImported(id: ID, url: URL, userID: ID) -> Domain {
        return Domain(
            id    : id,
            url   : url,
            owner : .user(userID: userID)
        )
    }

    func domainGrabbed() {
        owner = .us
    }
    
    func domainLost() {
        // TODO: implement
    }

    func domainChangedOwner(_ newOwner: Owner?) {
        owner = newOwner
    }

    func auctionOpened(seller: Owner, start: Date, end: Date) {
        auction = Auction(
            seller : seller,
            start  : start,
            end    : end
        )
    }

    func auctionCanceled() {
        business = .none
    }

    func auctionCompleted() {
        business = .none
    }

    func auctionExtended(newEndDate: Date) {
        auction.end = newEndDate
    }

    func bidAdded(bidID: ID, userID: ID, amount: Money) {
        auction.bids[bidID] = Auction.Bid(
            id     : bidID,
            userID : userID,
            amount : amount
        )
    }

    func bidCanceled(_ bidID: ID) {
        auction.bids[bidID]!.canceled = true
    }

    func saleOpened(seller: Owner, price: Money) {
        sale = Sale(seller: seller, price: price)
    }

    func saleCanceled() {
        business = .none
    }
    
    func purchaseRequested(userID: ID) {
        sale.purchase = Sale.Purchase(
            userID : userID,
            price  : sale.price
        )
    }

    func purchaseCanceled() {
        sale.purchase = .none
    }

    func purchaseCompleted() {
        business = .none
    }
}
