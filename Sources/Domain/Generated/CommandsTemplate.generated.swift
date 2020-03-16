// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Domain {

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

}

extension User {

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
        public let name: Name
        public let email: Email
        public let password: Password

        public init(id: ID, version: Int, name: Name, email: Email, password: Password) {
            self.id = id
            self.version = version
            self.name = name
            self.email = email
            self.password = password
        }
    }

    internal static func userRegistered(event: UserRegistered) -> User {
        return userRegistered(id: event.id, version: event.version, name: event.name, email: event.email, password: event.password)
    }

    public struct UserChangedEmail: Event {
        public let id: ID
        public let version: Int
        public let newEmail: Email

        public init(id: ID, version: Int, newEmail: Email) {
            self.id = id
            self.version = version
            self.newEmail = newEmail
        }
    }

    internal func userChangedEmail(event: UserChangedEmail) {
        userChangedEmail(newEmail: event.newEmail)
    }

    public struct UserChangedPassword: Event {
        public let id: ID
        public let version: Int
        public let newPassword: Password

        public init(id: ID, version: Int, newPassword: Password) {
            self.id = id
            self.version = version
            self.newPassword = newPassword
        }
    }

    internal func userChangedPassword(event: UserChangedPassword) {
        userChangedPassword(newPassword: event.newPassword)
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
