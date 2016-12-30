class Auction: Entity {
    let id     : ID
    let domain : Domain
    var bids   : [Bid]
    let start  : Date
    var end    : Date
    var status : Status
    
    init(
        id: ID = ID(),
        domain: Domain,
        bids: [Bid] = [],
        start: Date = .now,
        end: Date = .now + 10.days,
        status: Status = .active
    ) {
        self.id     = id
        self.domain = domain
        self.bids   = bids
        self.start  = start
        self.end    = end
        self.status = status
    }
}

extension Auction {
    func add(_ bid: Bid) {
        bids.append(bid)
        
        if end < .now + 1.hour {
            end = .now + 1.hour
        }
    }
}

extension Auction {
    enum Status {
        case active, completed, cancelled
    }
}
