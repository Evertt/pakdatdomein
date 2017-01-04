extension Domain {
    enum Event {
        case domainFound(domainID: ID, url: URL)
        case domainImported(domainID: ID, url: URL, userID: ID)
        case domainGrabbed
        case domainLost
        case domainChangedOwner(newOwner: Owner)

        case auctionOpened(auctionID: ID, owner: Owner, start: Date, end: Date)
        case auctionCanceled
        case auctionCompleted
        case auctionExtended(newEndDate: Date)
        
        case bidAdded(bidID: ID, userID: ID, amount: Money)
        case bidCanceled(bidID: ID)

        case saleOpened(saleID: ID, owner: Owner, price: Money)
        case saleCanceled

        case purchaseRequested(purchaseID: ID, userID: ID)
        case purchaseCanceled(purchaseID: ID)
        case purchaseCompleted(purchaseID: ID)
    }
}

extension Domain {
    static func apply(event: Event, to domain: Domain!) -> Domain {
        switch event {
        
        case let .domainImported(domainID, url, userID):
            return Domain(id: domainID, url: url, owner: .user(userID: userID))
            
        case let .domainFound(domainID, url):
            return Domain(id: domainID, url: url, owner: .outsider)
            
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

        case let .auctionOpened(auctionID, owner, start, end):
            let auction = Auction(
                id: auctionID,
                owner: owner,
                bids: [:],
                start: start,
                end: end,
                status: .active
            )

            domain.activeBusiness = .auction(auction)

        case .auctionCanceled:
            domain.activeBusiness.auction.status = .canceled
            domain.archivedBusiness.append(domain.activeBusiness!)
            domain.activeBusiness = .none

        case .auctionCompleted:
            domain.activeBusiness.auction.status = .completed
            domain.archivedBusiness.append(domain.activeBusiness!)
            domain.activeBusiness = .none

        case let .auctionExtended(newEndDate):
            domain.activeBusiness.auction.end = newEndDate

        case let .bidAdded(bidID, userID, amount):
            let bid = Bid(id: bidID, userID: userID, amount: amount)
            domain.activeBusiness.auction.bids[bidID] = bid

        case let .bidCanceled(bidID):
            domain.activeBusiness.auction.bids[bidID]!.canceled = true

        case let .saleOpened(saleID, owner, price):
            let sale = Sale(id: saleID, domainID: domain.id, owner: owner, price: price)
            domain.activeBusiness = .sale(sale)

        case .saleCanceled:
            domain.activeBusiness.sale.status = .canceled
            domain.archivedBusiness.append(domain.activeBusiness)
            domain.activeBusiness = .none

        case let .purchaseRequested(purchaseID, userID):
            let sale: Sale = domain.activeBusiness.sale
            
            sale.activePurchaseRequest = Purchase(
                id       : purchaseID,
                userID   : userID,
                domainID : sale.domainID,
                price    : sale.price,
                status   : .pending
            )
            
        case .purchaseCanceled:
            let sale: Sale = domain.activeBusiness.sale
            let purchase: Purchase = sale.activePurchaseRequest
            
            purchase.status = .canceled
            sale.archivedPurchaseRequests[purchase.id] = purchase
            sale.activePurchaseRequest = nil

        case .purchaseCompleted:
            let sale: Sale = domain.activeBusiness.sale
            
            sale.activePurchaseRequest.status = .completed
            sale.status = .completed
            domain.archivedBusiness.append(domain.activeBusiness)
            domain.activeBusiness = .none

        }
        
        return domain
    }
}
