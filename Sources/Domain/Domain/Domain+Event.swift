extension Domain {
    public struct DomainFound        : Event { public let id: ID, version: Int, url: URL }
    public struct DomainImported     : Event { public let id: ID, version: Int, url: URL, userID: ID }
    public struct DomainGrabbed      : Event { public let id: ID, version: Int }
    public struct DomainLost         : Event { public let id: ID, version: Int }
    public struct DomainChangedOwner : Event { public let id: ID, version: Int, newOwner: Owner? }
    
    public struct AuctionOpened      : Event { public let id: ID, version: Int, owner: Owner, start: Date, end: Date }
    public struct AuctionCanceled    : Event { public let id: ID, version: Int }
    public struct AuctionCompleted   : Event { public let id: ID, version: Int }
    public struct AuctionExtended    : Event { public let id: ID, version: Int, newEndDate: Date }
    
    public struct BidAdded           : Event { public let id: ID, version: Int, bidID: ID, userID: ID, amount: Money }
    public struct BidCanceled        : Event { public let id: ID, version: Int, bidID: ID }
    
    public struct SaleOpened         : Event { public let id: ID, version: Int, owner: Owner, price: Money }
    public struct SaleCanceled       : Event { public let id: ID, version: Int }

    public struct PurchaseRequested  : Event { public let id: ID, version: Int, userID: ID }
    public struct PurchaseCanceled   : Event { public let id: ID, version: Int }
    public struct PurchaseCompleted  : Event { public let id: ID, version: Int }
}

extension Domain {
    static func domainFound(event: DomainFound) -> Domain {
        return Domain(id: event.id, url: event.url, owner: nil, version: event.version)
    }

    static func domainImported(event: DomainImported) -> Domain {
        return Domain(
            id      : event.id,
            url     : event.url,
            owner   : .user(userID: event.userID),
            version : event.version
        )
    }

    func domainGrabbed(_: DomainGrabbed) {
        owner = .us
    }

    func domainChangedOwner(event: DomainChangedOwner) {
        owner = event.newOwner
    }

    func auctionOpened(event: AuctionOpened) {
        auction = Auction(
            owner: event.owner,
            start: event.start,
            end: event.end
        )
    }

    func auctionCanceled(event: AuctionCanceled) {
        business = .none
    }

    func auctionCompleted(event: AuctionCompleted) {
        business = .none
    }

    func auctionExtended(event: AuctionExtended) {
        auction.end = event.newEndDate
    }

    func bidAdded(event: BidAdded) {
        auction.bids[event.bidID] = Auction.Bid(
            id     : event.bidID,
            userID : event.userID,
            amount : event.amount
        )
    }

    func bidCanceled(event: BidCanceled) {
        auction.bids[event.bidID]!.canceled = true
    }

    func saleOpened(event: SaleOpened) {
        sale = Sale(owner: event.owner, price: event.price)
    }

    func saleCanceled(event: SaleCanceled) {
        business = .none
    }
    
    func purchaseRequested(event: PurchaseRequested) {
        sale.purchase = Sale.Purchase(userID: event.userID, price: sale.price)
    }

    func purchaseCanceled(event: PurchaseCanceled) {
        sale.purchase = .none
    }

    func purchaseCompleted(event: PurchaseCompleted) {
        business = .none
    }
}

extension Domain {
    public static let applies = __(
        ~domainFound,
        ~domainImported,
        ~domainGrabbed,
        ~domainChangedOwner,
        
        ~auctionOpened,
        ~auctionExtended,
        ~auctionCanceled,
        ~auctionCompleted,
        
        ~bidAdded,
        ~bidCanceled,
        
        ~saleOpened,
        ~saleCanceled,
        
        ~purchaseRequested,
        ~purchaseCanceled,
        ~purchaseCompleted
    )
}
