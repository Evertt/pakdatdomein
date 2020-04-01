extension Domain: AssertionChecker {
    /// These are all the things that can go wrong in this app
    
    public enum Assertion {
        case saleIsRunning
        case auctionIsRunning
        case noBusinessIsActive
        case bidIsActive(_ bidID: ID)
        
        case purchaseIsPending
        case noPurchaseIsPending
        
        case buyerIsNotSeller(_ buyerID: ID)
        case bidderIsNotSeller(_ bidderID: ID)
        
        case domainIsOwnedByUsOrOurUser
    }
    
    public func check(_ assertion: Assertion) -> Bool {
        switch assertion {

        case .noBusinessIsActive where business != nil,
             
             .saleIsRunning where business?.sale == nil,
             .auctionIsRunning where business?.auction == nil,
             
             .purchaseIsPending where business?.sale?.purchase == nil,
             .noPurchaseIsPending where business?.sale?.purchase != nil,
             
             .domainIsOwnedByUsOrOurUser where owner == nil:
            
            return false
                
        case let .bidIsActive(bidID) where business?.auction?.bids[bidID]?.canceled != false:
            return false
            
        case let .bidderIsNotSeller(bidder) where bidder == auction.seller:
            return false
            
        case let .buyerIsNotSeller(buyer) where buyer == sale.seller:
            return false
            
        default:
            return true
        }
    }
}
