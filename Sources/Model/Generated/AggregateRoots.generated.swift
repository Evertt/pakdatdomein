// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Domain {
    enum CodingKeys: String, CodingKey {
        case id, url, owner, business
    }

    public struct CreateFoundDomain: Command {
        public let id: ID
        public let url: URL

        public init(id: ID, url: URL) {
            self.id = id
            self.url = url
        }
    }

    public static func createFoundDomain(command: CreateFoundDomain) -> Domain {
        return createFoundDomain(id: command.id, url: command.url)
    }
    

    public struct GrabDomain: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func grabDomain(command: GrabDomain) {
        grabDomain()
    }
    

    public struct PutOnSale: Command {
        public let id: ID
        public let price: Money

        public init(id: ID, price: Money) {
            self.id = id
            self.price = price
        }
    }

    public func putOnSale(command: PutOnSale) throws {
        try putOnSale(price: command.price)
    }
    

    public struct RequestPurchase: Command {
        public let id: ID
        public let userID: ID

        public init(id: ID, userID: ID) {
            self.id = id
            self.userID = userID
        }
    }

    public func requestPurchase(command: RequestPurchase) throws {
        try requestPurchase(userID: command.userID)
    }
    

    public struct CancelPurchase: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func cancelPurchase(command: CancelPurchase) throws {
        try cancelPurchase()
    }
    

    public struct CancelSale: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func cancelSale(command: CancelSale) throws {
        try cancelSale()
    }
    

    public struct CompletePurchase: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func completePurchase(command: CompletePurchase) throws {
        try completePurchase()
    }
    

    public struct OpenAuction: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func openAuction(command: OpenAuction) throws {
        try openAuction()
    }
    

    public struct CancelAuction: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func cancelAuction(command: CancelAuction) throws {
        try cancelAuction()
    }
    

    public struct CompleteAuction: Command {
        public let id: ID
        

        public init(id: ID) {
            self.id = id
            
        }
    }

    public func completeAuction(command: CompleteAuction) throws {
        try completeAuction()
    }
    

    public struct ExtendAuction: Command {
        public let id: ID
        public let newEndDate: Date

        public init(id: ID, newEndDate: Date) {
            self.id = id
            self.newEndDate = newEndDate
        }
    }

    public func extendAuction(command: ExtendAuction) throws {
        try extendAuction(newEndDate: command.newEndDate)
    }
    

    public struct AddBid: Command {
        public let id: ID
        public let bidID: ID
        public let userID: ID
        public let amount: Money

        public init(id: ID, bidID: ID, userID: ID, amount: Money) {
            self.id = id
            self.bidID = bidID
            self.userID = userID
            self.amount = amount
        }
    }

    public func addBid(command: AddBid) throws {
        try addBid(bidID: command.bidID, userID: command.userID, amount: command.amount)
    }
    

    public struct CancelBid: Command {
        public let id: ID
        public let bidID: ID

        public init(id: ID, bidID: ID) {
            self.id = id
            self.bidID = bidID
        }
    }

    public func cancelBid(command: CancelBid) throws {
        try cancelBid(bidID: command.bidID)
    }
    

    public struct DomainFound: Event {
        public let id: ID
        public let version: Int
        public let url: URL

        public init(id: ID, version: Int = 1, url: URL) {
            self.id = id
            self.version = version
            self.url = url
        }
    }

    static func domainFound(event: DomainFound) -> Domain {
        return domainFound(id: event.id, url: event.url)
    }
    
     static func domainFound(id: ID, url: URL)  -> DomainFound {
        return DomainFound(id: id, url: url)
    }
    

    public struct DomainImported: Event {
        public let id: ID
        public let version: Int
        public let url: URL
        public let userID: ID

        public init(id: ID, version: Int = 1, url: URL, userID: ID) {
            self.id = id
            self.version = version
            self.url = url
            self.userID = userID
        }
    }

    static func domainImported(event: DomainImported) -> Domain {
        return domainImported(id: event.id, url: event.url, userID: event.userID)
    }
    
     static func domainImported(id: ID, url: URL, userID: ID)  -> DomainImported {
        return DomainImported(id: id, url: url, userID: userID)
    }
    

    public struct DomainGrabbed: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func domainGrabbed(event: DomainGrabbed) {
        return domainGrabbed()
    }
    
     func domainGrabbed()  -> DomainGrabbed {
        return DomainGrabbed(id: id, version: version)
    }
    

    public struct DomainLost: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func domainLost(event: DomainLost) {
        return domainLost()
    }
    
     func domainLost()  -> DomainLost {
        return DomainLost(id: id, version: version)
    }
    

    public struct DomainChangedOwner: Event {
        public let id: ID
        public let version: Int
        public let newOwner: Owner?

        public init(id: ID, version: Int = 1, newOwner: Owner?) {
            self.id = id
            self.version = version
            self.newOwner = newOwner
        }
    }

    func domainChangedOwner(event: DomainChangedOwner) {
        return domainChangedOwner(event.newOwner)
    }
    
     func domainChangedOwner(_ newOwner: Owner?)  -> DomainChangedOwner {
        return DomainChangedOwner(id: id, version: version, newOwner: newOwner)
    }
    

    public struct AuctionOpened: Event {
        public let id: ID
        public let version: Int
        public let seller: Owner
        public let start: Date
        public let end: Date

        public init(id: ID, version: Int = 1, seller: Owner, start: Date, end: Date) {
            self.id = id
            self.version = version
            self.seller = seller
            self.start = start
            self.end = end
        }
    }

    func auctionOpened(event: AuctionOpened) {
        return auctionOpened(seller: event.seller, start: event.start, end: event.end)
    }
    
     func auctionOpened(seller: Owner, start: Date, end: Date)  -> AuctionOpened {
        return AuctionOpened(id: id, version: version, seller: seller, start: start, end: end)
    }
    

    public struct AuctionCanceled: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func auctionCanceled(event: AuctionCanceled) {
        return auctionCanceled()
    }
    
     func auctionCanceled()  -> AuctionCanceled {
        return AuctionCanceled(id: id, version: version)
    }
    

    public struct AuctionCompleted: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func auctionCompleted(event: AuctionCompleted) {
        return auctionCompleted()
    }
    
     func auctionCompleted()  -> AuctionCompleted {
        return AuctionCompleted(id: id, version: version)
    }
    

    public struct AuctionExtended: Event {
        public let id: ID
        public let version: Int
        public let newEndDate: Date

        public init(id: ID, version: Int = 1, newEndDate: Date) {
            self.id = id
            self.version = version
            self.newEndDate = newEndDate
        }
    }

    func auctionExtended(event: AuctionExtended) {
        return auctionExtended(newEndDate: event.newEndDate)
    }
    
     func auctionExtended(newEndDate: Date)  -> AuctionExtended {
        return AuctionExtended(id: id, version: version, newEndDate: newEndDate)
    }
    

    public struct BidAdded: Event {
        public let id: ID
        public let version: Int
        public let bidID: ID
        public let userID: ID
        public let amount: Money

        public init(id: ID, version: Int = 1, bidID: ID, userID: ID, amount: Money) {
            self.id = id
            self.version = version
            self.bidID = bidID
            self.userID = userID
            self.amount = amount
        }
    }

    func bidAdded(event: BidAdded) {
        return bidAdded(bidID: event.bidID, userID: event.userID, amount: event.amount)
    }
    
     func bidAdded(bidID: ID, userID: ID, amount: Money)  -> BidAdded {
        return BidAdded(id: id, version: version, bidID: bidID, userID: userID, amount: amount)
    }
    

    public struct BidCanceled: Event {
        public let id: ID
        public let version: Int
        public let bidID: ID

        public init(id: ID, version: Int = 1, bidID: ID) {
            self.id = id
            self.version = version
            self.bidID = bidID
        }
    }

    func bidCanceled(event: BidCanceled) {
        return bidCanceled(event.bidID)
    }
    
     func bidCanceled(_ bidID: ID)  -> BidCanceled {
        return BidCanceled(id: id, version: version, bidID: bidID)
    }
    

    public struct SaleOpened: Event {
        public let id: ID
        public let version: Int
        public let seller: Owner
        public let price: Money

        public init(id: ID, version: Int = 1, seller: Owner, price: Money) {
            self.id = id
            self.version = version
            self.seller = seller
            self.price = price
        }
    }

    func saleOpened(event: SaleOpened) {
        return saleOpened(seller: event.seller, price: event.price)
    }
    
     func saleOpened(seller: Owner, price: Money)  -> SaleOpened {
        return SaleOpened(id: id, version: version, seller: seller, price: price)
    }
    

    public struct SaleCanceled: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func saleCanceled(event: SaleCanceled) {
        return saleCanceled()
    }
    
     func saleCanceled()  -> SaleCanceled {
        return SaleCanceled(id: id, version: version)
    }
    

    public struct PurchaseRequested: Event {
        public let id: ID
        public let version: Int
        public let userID: ID

        public init(id: ID, version: Int = 1, userID: ID) {
            self.id = id
            self.version = version
            self.userID = userID
        }
    }

    func purchaseRequested(event: PurchaseRequested) {
        return purchaseRequested(userID: event.userID)
    }
    
     func purchaseRequested(userID: ID)  -> PurchaseRequested {
        return PurchaseRequested(id: id, version: version, userID: userID)
    }
    

    public struct PurchaseCanceled: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func purchaseCanceled(event: PurchaseCanceled) {
        return purchaseCanceled()
    }
    
     func purchaseCanceled()  -> PurchaseCanceled {
        return PurchaseCanceled(id: id, version: version)
    }
    

    public struct PurchaseCompleted: Event {
        public let id: ID
        public let version: Int
        

        public init(id: ID, version: Int = 1) {
            self.id = id
            self.version = version
            
        }
    }

    func purchaseCompleted(event: PurchaseCompleted) {
        return purchaseCompleted()
    }
    
     func purchaseCompleted()  -> PurchaseCompleted {
        return PurchaseCompleted(id: id, version: version)
    }
    

    public static let handles = __(
        ~createFoundDomain,
        ~grabDomain,
        ~putOnSale,
        ~requestPurchase,
        ~cancelPurchase,
        ~cancelSale,
        ~completePurchase,
        ~openAuction,
        ~cancelAuction,
        ~completeAuction,
        ~extendAuction,
        ~addBid,
        ~cancelBid
    )

    public static let applies = __(
        ~domainFound,
        ~domainImported,
        ~domainGrabbed,
        ~domainLost,
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

}

extension User {
    enum CodingKeys: String, CodingKey {
        case id, name, email, password, active
    }

    public struct Register: Command {
        public let id: ID
        public let name: String
        public let email: String
        public let password: String

        public init(id: ID, name: String, email: String, password: String) {
            self.id = id
            self.name = name
            self.email = email
            self.password = password
        }
    }

    public static func register(command: Register) throws -> User {
        return try register(id: command.id, name: command.name, email: command.email, password: command.password)
    }
    

    public struct ChangeEmail: Command {
        public let id: ID
        public let newEmail: String

        public init(id: ID, newEmail: String) {
            self.id = id
            self.newEmail = newEmail
        }
    }

    public func changeEmail(command: ChangeEmail) throws {
        try changeEmail(newEmail: command.newEmail)
    }
    

    public struct ChangePassword: Command {
        public let id: ID
        public let newPassword: String

        public init(id: ID, newPassword: String) {
            self.id = id
            self.newPassword = newPassword
        }
    }

    public func changePassword(command: ChangePassword) throws {
        try changePassword(newPassword: command.newPassword)
    }
    

    public struct UserRegistered: Event {
        public let id: ID
        public let version: Int
        public let name: String
        public let email: String
        public let password: String

        public init(id: ID, version: Int = 1, name: String, email: String, password: String) {
            self.id = id
            self.version = version
            self.name = name
            self.email = email
            self.password = password
        }
    }

    static func userRegistered(event: UserRegistered) -> User {
        return userRegistered(id: event.id, name: event.name, email: event.email, password: event.password)
    }
    
     static func userRegistered(id: ID, name: String, email: String, password: String)  -> UserRegistered {
        return UserRegistered(id: id, name: name, email: email, password: password)
    }
    

    public struct UserChangedEmail: Event {
        public let id: ID
        public let version: Int
        public let newEmail: String

        public init(id: ID, version: Int = 1, newEmail: String) {
            self.id = id
            self.version = version
            self.newEmail = newEmail
        }
    }

    func userChangedEmail(event: UserChangedEmail) {
        return userChangedEmail(event.newEmail)
    }
    
     func userChangedEmail(_ newEmail: String)  -> UserChangedEmail {
        return UserChangedEmail(id: id, version: version, newEmail: newEmail)
    }
    

    public struct UserChangedPassword: Event {
        public let id: ID
        public let version: Int
        public let newPassword: String

        public init(id: ID, version: Int = 1, newPassword: String) {
            self.id = id
            self.version = version
            self.newPassword = newPassword
        }
    }

    func userChangedPassword(event: UserChangedPassword) {
        return userChangedPassword(event.newPassword)
    }
    
     func userChangedPassword(_ newPassword: String)  -> UserChangedPassword {
        return UserChangedPassword(id: id, version: version, newPassword: newPassword)
    }
    

    public static let handles = __(
        ~register,
        ~changeEmail,
        ~changePassword
    )

    public static let applies = __(
        ~userRegistered,
        ~userChangedEmail,
        ~userChangedPassword
    )

}

