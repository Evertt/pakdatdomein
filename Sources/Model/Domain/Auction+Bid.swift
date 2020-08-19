extension Domain {
    struct Auction: Codable {
        let seller : Owner
        let start  : Date
        var end    : Date
        var bids   : [ID:Bid] = [:]
    }
}

extension Domain.Auction {
    struct Bid: Codable {
        let id       : ID
        let userID   : ID
        let amount   : Money
        var canceled : Bool = false
    }
}
