extension Domain {
    struct PutOnSale        : Task { let price: Money }
    struct RequestPurchase  : Task { let userID: ID }
    struct CancelSale       : Task { }
    struct CancelPurchase   : Task { }
    struct CompletePurchase : Task { }
    struct OpenAuction      : Task { }
    struct CancelAuction    : Task { }
    struct CompleteAuction  : Task { }
    struct ExtendAuction    : Task { let newEndDate: Date }
    struct AddBid           : Task { let bidID: ID, userID: ID, amount: Money }
    struct CancelBid        : Task { let bidID: ID }
}

extension Domain {
    static let handles = __(
        ~putOnSale,
        ~requestPurchase,
        ~cancelSale,
        ~cancelPurchase,
        ~completePurchase,
        ~openAuction,
        ~cancelAuction,
        ~completeAuction,
        ~extendAuction,
        ~addBid,
        ~cancelBid
    )

    func putOnSale(task: PutOnSale) throws {
        try ensure(.noBusinessIsActive)
        
        apply(SaleOpened(owner: owner, price: task.price))
    }

    func requestPurchase(task: RequestPurchase) throws {
        try ensure(.saleIsRunning)
        try ensure(.noPendingPurchase)
        
        apply(PurchaseRequested(userID: task.userID))
    }

    func cancelPurchase(task: CancelPurchase) throws {
        try ensure(.purchaseIsPending)
        
        apply(PurchaseCanceled())
    }

    func cancelSale(task: CancelSale) throws {
        try ensure(.saleIsRunning)
        
        if check(.purchaseIsPending) {
            apply(PurchaseCanceled())
        }
        
        apply(SaleCanceled())
    }

    func completePurchase(task: CompletePurchase) throws {
        try ensure(.purchaseIsPending)

        let userID   = sale.purchase.userID
        let newOwner = Owner.user(userID: userID)

        apply(PurchaseCompleted())
        apply(DomainChangedOwner(newOwner: newOwner))
    }

    func openAuction(task: OpenAuction) throws {
        try ensure(.noBusinessIsActive)
        
        apply(AuctionOpened(
            owner: owner,
            start: .now,
            end: .now + Default.durationOfAuction
        ))
    }

    func cancelAuction(task: CancelAuction) throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionCanceled())
    }

    func completeAuction(task: CompleteAuction) throws {
        try ensure(.auctionIsRunning)

        apply(AuctionCompleted())
        
        let bid: Auction.Bid? = auction.bids.reduce(nil) {
            result, item in
            
            guard let amount = result?.amount else {
                return item.value
            }
            
            if item.value.amount > amount {
                return item.value
            }
            
            return result
        }

        if let bid = bid {
            let newOwner = Owner.user(userID: bid.userID)

            apply(DomainChangedOwner(newOwner: newOwner))
        }
    }

    func extendAuction(task: ExtendAuction) throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionExtended(newEndDate: task.newEndDate))
    }

    func addBid(task: AddBid) throws {
        try ensure(.auctionIsRunning)
        
        apply(BidAdded(
            bidID  : task.bidID,
            userID : task.userID,
            amount : task.amount
        ))
        
        if auction.end < .now + 1.hour {
            let newDate: Date = .now + 1.hour
            
            apply(AuctionExtended(newEndDate: newDate))
        }
    }

    func cancelBid(task: CancelBid) throws {
        try ensure(.bidIsActive(task.bidID))
        
        apply(BidCanceled(bidID: task.bidID))
    }
}
