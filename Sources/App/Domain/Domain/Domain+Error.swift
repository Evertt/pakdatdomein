extension Domain {
    enum Error: Swift.Error {
        case invalidStuff
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
            throw Error.invalidStuff
            
        case .auctionIsRunning where business?.auction == nil:
            throw Error.invalidStuff
            
        case .saleIsRunning where business?.sale == nil:
            throw Error.invalidStuff
            
        case .bidIsActive(let bidID) where business?.auction?.bids[bidID]?.canceled != false:
            throw Error.invalidStuff
            
        case .noPendingPurchase where business?.sale?.purchase != nil:
            throw Error.invalidStuff
            
        case .purchaseIsPending where business?.sale?.purchase == nil:
            throw Error.invalidStuff
            
        default: break
        }
    }
    
    func check(_ check: Check) -> Bool {
        return (try? ensure(check)) != nil
    }
}
