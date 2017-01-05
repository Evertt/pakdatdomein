extension Domain {
    final class Bid: Aggregate {
        let id       : ID
        let userID   : ID
        let amount   : Money
        var canceled : Bool
        
        init(
            id       : ID,
            userID   : ID,
            amount   : Money,
            canceled : Bool = false
        ) {
            self.id       = id
            self.userID   = userID
            self.amount   = amount
            self.canceled = canceled
        }
    }
}
