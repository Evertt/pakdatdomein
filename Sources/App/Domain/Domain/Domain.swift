final class Domain: AggregateRoot {
    let id               : ID
    let url              : URL
    var owner            : Owner
    var activeBusiness   : Business!
    var archivedBusiness : [Business]

    var uncommittedEvents = [Event]()
    
    init(
        id               : ID,
        url              : URL,
        owner            : Owner,
        activeBusiness   : Business? = nil,
        archivedBusiness : [Business] = []
    ) {
        self.id               = id
        self.url              = url
        self.owner            = owner
        self.activeBusiness   = activeBusiness
        self.archivedBusiness = archivedBusiness
    }
    
    func putOnSale(saleID: ID, price: Money) throws -> Domain {
        guard activeBusiness == nil else {
            throw Error.invalidStuff
        }
        
        return apply(event: .saleOpened(saleID: saleID, owner: owner, price: price))
    }
    
    func putOnAuction(auctionID: ID) throws -> Domain {
        guard activeBusiness == nil else {
            throw Error.invalidStuff
        }
        
        return apply(event: .auctionOpened(
            auctionID: auctionID,
            owner: owner,
            start: .now,
            end: .now + Default.durationOfAuction
        ))
    }
}

extension Domain {
    enum Error: Swift.Error {
        case invalidStuff
    }
}
