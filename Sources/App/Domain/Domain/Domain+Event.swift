extension Domain {
    struct DomainFound        : Event { let id: ID, url: URL }
    struct DomainImported     : Event { let id: ID, url: URL, userID: ID }
    struct DomainGrabbed      : Event { }
    struct DomainChangedOwner : Event { let newOwner: Owner }
    
    struct AuctionOpened      : Event { let owner: Owner, start: Date, end: Date }
    struct AuctionCanceled    : Event { }
    struct AuctionCompleted   : Event { }
    struct AuctionExtended    : Event { let newEndDate: Date }
    
    struct BidAdded           : Event { let bidID: ID, userID: ID, amount: Money }
    struct BidCanceled        : Event { let bidID: ID }
    
    struct SaleOpened         : Event { let owner: Owner, price: Money }
    struct SaleCanceled       : Event { }

    struct PurchaseRequested  : Event { let userID: ID }
    struct PurchaseCanceled   : Event { }
    struct PurchaseCompleted  : Event { }
}

extension Domain {
    static let applies = __(
        ~domainFound,
        ~domainImported,
        ~domainGrabbed,
        ~domainChangedOwner,
        ~auctionOpened,
        ~auctionCanceled,
        ~auctionCompleted,
        ~auctionExtended,
        ~bidAdded,
        ~bidCanceled,
        ~saleOpened,
        ~saleCanceled,
        ~purchaseRequested,
        ~purchaseCanceled,
        ~purchaseCompleted
    )

    static func domainFound(event: DomainFound) -> Domain {
        return Domain(id: event.id, url: event.url, owner: nil)
    }

    static func domainImported(event: DomainImported) -> Domain {
        return Domain(
            id    : event.id,
            url   : event.url,
            owner : .user(userID: event.userID)
        )
    }

    func domainGrabbed(event: DomainGrabbed) {
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
