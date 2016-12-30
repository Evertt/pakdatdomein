final class Auction: AggregateRoot {
    let id       : ID
    let domainID : ID
    var bids     : [ID:Bid]
    let start    : Date
    var end      : Date
    var status   : Status
    
    init(
        id       : ID,
        domainID : ID,
        bids     : [ID:Bid] = [:],
        start    : Date = .now,
        end      : Date = .now + Default.durationOfAuction,
        status   : Status = .active
    ) {
        self.id       = id
        self.domainID = domainID
        self.bids     = bids
        self.start    = start
        self.end      = end
        self.status   = status
    }
}
