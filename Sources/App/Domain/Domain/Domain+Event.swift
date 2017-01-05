extension Domain {
    enum Event {
        case domainFound(domainID: ID, url: URL)
        case domainImported(domainID: ID, url: URL, userID: ID)
        case domainGrabbed
        case domainLost
        case domainChangedOwner(newOwner: Owner)

        case auctionOpened(owner: Owner, start: Date, end: Date)
        case auctionCanceled
        case auctionCompleted
        case auctionExtended(newEndDate: Date)
        
        case bidAdded(bidID: ID, userID: ID, amount: Money)
        case bidCanceled(bidID: ID)

        case saleOpened(owner: Owner, price: Money)
        case saleCanceled

        case purchaseRequested(userID: ID)
        case purchaseCanceled
        case purchaseCompleted
    }
}

extension Domain {
    static func apply(event: Event, to domain: Domain!) -> Domain {
        switch event {
        
        case let .domainImported(domainID, url, userID):
            return Domain(id: domainID, url: url, owner: .user(userID: userID))
            
        case let .domainFound(domainID, url):
            return Domain(id: domainID, url: url, owner: nil)
            
        case .domainGrabbed:
            domain.owner = .us
        
        case .domainLost: break
//            switch domain.activeBusiness {
//            case let .sale(sale)?:
//                try! sale.cancel()
//            case let .auction(auction)?:
//                try! auction.cancel()
//            default:
//                break
//            }

        case let .domainChangedOwner(newOwner):
            domain.owner = newOwner

        case let .auctionOpened(owner, start, end):
            let auction = Auction(
                owner: owner,
                bids: [:],
                start: start,
                end: end
            )

            domain.business = .auction(auction)

        case .auctionCanceled, .auctionCompleted,
             .saleCanceled, .purchaseCompleted:
            domain.business = .none

        case let .auctionExtended(newEndDate):
            domain.business.auction.end = newEndDate

        case let .bidAdded(bidID, userID, amount):
            let bid = Bid(id: bidID, userID: userID, amount: amount)
            domain.business.auction.bids[bidID] = bid

        case let .bidCanceled(bidID):
            domain.business.auction.bids[bidID]!.canceled = true

        case let .saleOpened(owner, price):
            domain.business = .sale(Sale(owner: owner, price: price))

        case let .purchaseRequested(userID):
            var sale: Sale = domain.business.sale
            sale.purchase = Sale.Purchase(userID: userID, price: sale.price)
            domain.business.sale = sale
            
        case .purchaseCanceled:
            domain.business.sale.purchase = .none

        }
        
        return domain
    }
}
