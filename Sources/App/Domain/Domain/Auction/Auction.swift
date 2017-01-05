extension Domain {
    struct Auction {
        let owner  : Owner
        var bids   : [ID:Bid]
        let start  : Date
        var end    : Date
        
        init(owner: Domain.Owner, bids: [ID:Bid], start: Date, end: Date) {
            self.owner    = owner
            self.bids     = bids
            self.start    = start
            self.end      = end
        }
    }
}
