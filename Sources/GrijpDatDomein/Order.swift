class Order: Entity {
    let id     : ID
    let user   : User
    let domain : Domain
    let price  : Money
    var status : Status

    init(id: ID = ID(), user: User, domain: Domain, price: Money, status: Status = .active) {
        self.id     = id
        self.user   = user
        self.domain = domain
        self.price  = price
        self.status = status
    }
}

extension Order {
    enum Status {
        case active, completed, cancelled //, converted(to: Auction)
    }
}
