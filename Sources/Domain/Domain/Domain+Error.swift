extension Domain {
    enum Error: Swift.Error {
        case businessIsActive
        case noSaleIsRunning
        case noAuctionIsRunning
        case noBidIsActive(ID)
        case purchaseIsPending
        case noPendingPurchase
        case ownedByOutsider
    }
    
    enum Check {
        case noBusinessIsActive
        case saleIsRunning
        case auctionIsRunning
        case bidIsActive(ID)
        case noPendingPurchase
        case purchaseIsPending
    }

    func ensure(_ check: Check) throws {
        switch check {

        case .noBusinessIsActive where business != nil:
            throw Error.businessIsActive
            
        case .auctionIsRunning where business?.auction == nil:
            throw Error.noAuctionIsRunning
            
        case .saleIsRunning where business?.sale == nil:
            throw Error.noSaleIsRunning
            
        case .bidIsActive(let bidID) where business?.auction?.bids[bidID]?.canceled != false:
            throw Error.noBidIsActive(bidID)
            
        case .noPendingPurchase where business?.sale?.purchase != nil:
            throw Error.purchaseIsPending
            
        case .purchaseIsPending where business?.sale?.purchase == nil:
            throw Error.noPendingPurchase
            
        default: break
        }
    }
    
    func check(_ check: Check) -> Bool {
        return (try? ensure(check)) != nil
    }
}
