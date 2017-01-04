final class Auction: AggregateRoot {
    let id     : ID
    let owner  : Domain.Owner
    var bids   : [ID:Bid]
    let start  : Date
    var end    : Date
    var status : Status
    
    var uncommittedEvents = [Event]()
    
    init(id: ID, owner: Domain.Owner, bids: [ID:Bid], start: Date, end: Date, status: Status) {
        self.id       = id
        self.owner    = owner
        self.bids     = bids
        self.start    = start
        self.end      = end
        self.status   = status
    }
    
    static func open(auctionID: ID, owner: Domain.Owner) -> Auction {
        let start : Date = .now
        let end   : Date = start + Default.durationOfAuction
        let openingEvent = Event.auctionOpened(
            auctionID: auctionID, owner: owner, start: start, end: end
        )
        
        return apply(event: openingEvent)
    }
    
    func addBid(bidID: ID, userID: ID, amount: Money) throws -> Auction {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        return apply(event: .bidAdded(bidID: bidID, userID: userID, amount: amount))
    }
    
    func cancelBid(bidID: ID) throws -> Auction {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        return apply(event: .bidCanceled(bidID: bidID))
    }
    
    func cancel() throws -> Auction {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        return apply(event: .auctionCanceled)
    }
    
    func complete() throws -> Auction {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        return apply(event: .auctionCompleted)
    }
    
    func extend(to newDate: Date) throws -> Auction {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        return apply(event: .auctionExtended(newEndDate: newDate))
    }
}
