final class Purchase: Aggregate {
    let id       : ID
    let userID   : ID
    let domainID : ID
    let price    : Money
    var status   : Status

    init(
        id       : ID,
        userID   : ID,
        domainID : ID,
        price    : Money,
        status   : Status = .pending
    ) {
        self.id       = id
        self.userID   = userID
        self.domainID = domainID
        self.price    = price
        self.status   = status
    }
}

extension Purchase {
    enum Status {
        case pending, canceled, completed
    }
}
