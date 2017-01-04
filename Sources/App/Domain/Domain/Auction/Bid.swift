final class Bid: Aggregate {
    let id       : ID
    let userID   : ID
    let amount   : Money
    let created  : Date
    var canceled : Bool
    
    init(
        id       : ID,
        userID   : ID,
        amount   : Money,
        created  : Date = .now,
        canceled : Bool = false
    ) {
        self.id       = id
        self.userID   = userID
        self.amount   = amount
        self.created  = created
        self.canceled = canceled
    }
}