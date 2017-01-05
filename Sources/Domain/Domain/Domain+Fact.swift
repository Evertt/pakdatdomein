extension Domain {
    struct DomainFound        : Fact { let id: ID, url: URL }
    struct DomainImported     : Fact { let id: ID, url: URL, userID: ID }
    struct DomainGrabbed      : Fact { }
    struct DomainChangedOwner : Fact { let newOwner: Owner? }
    
    struct AuctionOpened      : Fact { let owner: Owner, start: Date, end: Date }
    struct AuctionCanceled    : Fact { }
    struct AuctionCompleted   : Fact { }
    struct AuctionExtended    : Fact { let newEndDate: Date }
    
    struct BidAdded           : Fact { let bidID: ID, userID: ID, amount: Money }
    struct BidCanceled        : Fact { let bidID: ID }
    
    struct SaleOpened         : Fact { let owner: Owner, price: Money }
    struct SaleCanceled       : Fact { }

    struct PurchaseRequested  : Fact { let userID: ID }
    struct PurchaseCanceled   : Fact { }
    struct PurchaseCompleted  : Fact { }
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

    static func domainFound(fact: DomainFound) -> Domain {
        return Domain(id: fact.id, url: fact.url, owner: nil)
    }

    static func domainImported(fact: DomainImported) -> Domain {
        return Domain(
            id    : fact.id,
            url   : fact.url,
            owner : .user(userID: fact.userID)
        )
    }

    func domainGrabbed(fact: DomainGrabbed) {
        owner = .us
    }

    func domainChangedOwner(fact: DomainChangedOwner) {
        owner = fact.newOwner
    }

    func auctionOpened(fact: AuctionOpened) {
        auction = Auction(
            owner: fact.owner,
            start: fact.start,
            end: fact.end
        )
    }

    func auctionCanceled(fact: AuctionCanceled) {
        business = .none
    }

    func auctionCompleted(fact: AuctionCompleted) {
        business = .none
    }

    func auctionExtended(fact: AuctionExtended) {
        auction.end = fact.newEndDate
    }

    func bidAdded(fact: BidAdded) {
        auction.bids[fact.bidID] = Auction.Bid(
            id     : fact.bidID,
            userID : fact.userID,
            amount : fact.amount
        )
    }

    func bidCanceled(fact: BidCanceled) {
        auction.bids[fact.bidID]!.canceled = true
    }

    func saleOpened(fact: SaleOpened) {
        sale = Sale(owner: fact.owner, price: fact.price)
    }

    func saleCanceled(fact: SaleCanceled) {
        business = .none
    }
    
    func purchaseRequested(fact: PurchaseRequested) {
        sale.purchase = Sale.Purchase(userID: fact.userID, price: sale.price)
    }

    func purchaseCanceled(fact: PurchaseCanceled) {
        sale.purchase = .none
    }

    func purchaseCompleted(fact: PurchaseCompleted) {
        business = .none
    }
}
