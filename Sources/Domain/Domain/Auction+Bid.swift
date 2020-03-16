extension Domain {
    struct Auction: Codable {
        let owner  : Owner
        let start  : Date
        var end    : Date
        var bids   : [ID:Bid] = [:]
        
        init(owner: Domain.Owner, start: Date, end: Date) {
            self.owner = owner
            self.start = start
            self.end   = end
        }
    }
}

extension Domain.Auction {
    final class Bid: Entity {
        let id       : ID
        let userID   : ID
        let amount   : Money
        var canceled : Bool = false
        
        init(id: ID, userID: ID, amount: Money) {
            self.id     = id
            self.userID = userID
            self.amount = amount
        }
    }
}
