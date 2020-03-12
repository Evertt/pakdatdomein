extension Domain {
    public struct CreateFoundDomain: Command {
        public let id: ID, url: URL
        
        public init(id: ID, url: URL) {
            self.id  = id
            self.url = url
        }
    }

    public struct PutOnSale: Command {
        public let id: ID, price: Money
        
        public init(id: ID, price: Money) {
            self.id    = id
            self.price = price
        }
    }
    
    public struct RequestPurchase: Command {
        public let id: ID, userID: ID

        public init(id: ID, userID: ID) {
            self.id     = id
            self.userID = userID
        }
    }

    public struct ExtendAuction: Command {
        public let id: ID, newEndDate: Date

        public init(id: ID, newEndDate: Date) {
            self.id         = id
            self.newEndDate = newEndDate
        }
    }

    public struct AddBid: Command {
        public let id: ID, bidID: ID, userID: ID, amount: Money

        public init(id: ID, bidID: ID, userID: ID, amount: Money) {
            self.id     = id
            self.bidID  = bidID
            self.userID = userID
            self.amount = amount
        }
    }
    
    public struct CancelBid: Command {
        public let id: ID, bidID: ID

        public init(id: ID, bidID: ID) {
            self.id     = id
            self.bidID = bidID
        }
    }

    public struct GrabDomain       : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct CancelSale       : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct CancelPurchase   : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct CompletePurchase : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct OpenAuction      : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct CancelAuction    : Command { public let id: ID; public init(id: ID) { self.id = id } }
    public struct CompleteAuction  : Command { public let id: ID; public init(id: ID) { self.id = id } }
}

extension Domain {
    static func createFoundDomain(command: CreateFoundDomain) -> Domain {
        return apply(DomainFound(id: command.id, version: 1, url: command.url))
    }
    
    func grabDomain(command: GrabDomain) {
        apply(DomainGrabbed(id: id, version: version))
    }

    func putOnSale(command: PutOnSale) throws {
        try ensure(.noBusinessIsActive)
        
        apply(SaleOpened(id: id, version: version, owner: owner, price: command.price))
    }

    func requestPurchase(command: RequestPurchase) throws {
        try ensure(.saleIsRunning, .noPendingPurchase)
        
        apply(PurchaseRequested(id: id, version: version, userID: command.userID))
    }

    func cancelPurchase(command: CancelPurchase) throws {
        try ensure(.purchaseIsPending)
        
        apply(PurchaseCanceled(id: id, version: version))
    }

    func cancelSale(command: CancelSale) throws {
        try ensure(.saleIsRunning)
        
        if check(.purchaseIsPending) {
            apply(PurchaseCanceled(id: id, version: version))
        }
        
        apply(SaleCanceled(id: id, version: version))
    }

    func completePurchase(command: CompletePurchase) throws {
        try ensure(.purchaseIsPending)

        let userID   = sale.purchase!.userID
        let newOwner = Owner.user(userID: userID)

        apply(PurchaseCompleted(id: id, version: version))
        apply(DomainChangedOwner(id: id, version: version, newOwner: newOwner))
    }

    func openAuction(command: OpenAuction) throws {
        try ensure(.noBusinessIsActive)
        
        apply(AuctionOpened(
            id      : id,
            version : version,
            owner   : owner ?? .us,
            start   : .now,
            end     : .now + Default.durationOfAuction
        ))
    }

    func cancelAuction(command: CancelAuction) throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionCanceled(id: id, version: version))
    }

    func completeAuction(command: CompleteAuction) throws {
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

    func extendAuction(command: ExtendAuction) throws {
        try ensure(.auctionIsRunning)
        
        apply(AuctionExtended(id: id, version: version, newEndDate: command.newEndDate))
    }

    func addBid(command: AddBid) throws {
        try ensure(.auctionIsRunning)
        
        apply(BidAdded(
            id      : id,
            version : version, 
            bidID   : command.bidID,
            userID  : command.userID,
            amount  : command.amount
        ))
        
        if auction.end < .now + 1.hour {
            let newDate: Date = .now + 1.hour
            
            apply(AuctionExtended(id: id, version: version, newEndDate: newDate))
        }
    }

    func cancelBid(command: CancelBid) throws {
        try ensure(.bidIsActive(command.bidID))
        
        apply(BidCanceled(id: id, version: version, bidID: command.bidID))
    }
}

extension Domain {
    public static let handles = __(
        ~createFoundDomain,
        ~grabDomain,

        ~putOnSale,
        ~cancelSale,

        ~requestPurchase,
        ~cancelPurchase,
        ~completePurchase,

        ~openAuction,
        ~extendAuction,
        ~cancelAuction,
        ~completeAuction,

        ~addBid,
        ~cancelBid
    )
}
