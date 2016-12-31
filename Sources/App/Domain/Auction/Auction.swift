final class Auction: AggregateRoot {
    let id       : ID
    let domainID : ID
    var bids     : [ID:Bid]
    let start    : Date
    var end      : Date
    var status   : Status
    
    var uncommittedEvents = [Event]()
    
    init(
        id       : ID,
        domainID : ID,
        bids     : [ID:Bid],
        start    : Date,
        end      : Date,
        status   : Status
    ) {
        self.id       = id
        self.domainID = domainID
        self.bids     = bids
        self.start    = start
        self.end      = end
        self.status   = status
    }
    
    static func open(auctionID: ID, domainID: ID) -> Auction {
        let start : Date = .now
        let end   : Date = start + Default.durationOfAuction
        let openingEvent = Event.auctionOpened(
            auctionID: auctionID, domainID: domainID, start: start, end: end
        )
        
        return fire(event: openingEvent)
    }
    
    func addBid(bidID: ID, userID: ID, amount: Money) throws {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        fire(event: .bidAdded(bidID: bidID, userID: userID, amount: amount))
    }
    
    func cancelBid(bidID: ID) throws {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        fire(event: .bidCanceled(bidID: bidID))
    }
    
    func cancel() throws {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        fire(event: .auctionCanceled)
    }
    
    func complete() throws {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        fire(event: .auctionCompleted)
    }
    
    func extend(to newDate: Date) throws {
        guard status == .active else {
            throw Error.invalidStuff
        }
        
        fire(event: .auctionExtended(newEndDate: newDate))
    }
}

extension Auction {
    enum Error: Swift.Error {
        case invalidStuff
    }
}
