extension Domain {
    struct Auction: Codable {
        let seller : Owner
        let start  : Date
        var end    : Date
        var bids   : [ID:Bid] = [:]
        
        init(seller: Domain.Owner, start: Date, end: Date) {
            self.seller = seller
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
