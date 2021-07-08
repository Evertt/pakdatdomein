extension Domain: AssertionChecker {
    public indirect enum Assertion {
        case saleIsRunning
        case auctionIsRunning
        case businessIsActive
        case purchaseIsPending
        case bidIsActive(_ bidID: ID)
        
        case bidderIsNotSeller(_ bidderID: ID)
        case buyerIsNotSeller(_ buyerID: ID)
        
        case domainIsOwnedByUsOrOurUser
        
        case no(_ assertion: Assertion)
    }
    
    public func check(_ assertion: Assertion) -> Bool {
        switch assertion {
             
        case .saleIsRunning:
            return sale != nil

        case .auctionIsRunning:
            return auction != nil
            
        case .businessIsActive:
            return business != nil

        case .purchaseIsPending:
            return business?.sale?.purchase != nil
                
        case .bidIsActive(let bidID):
            guard let bid = business?.auction?.bids[bidID] else {
                return false
            }
            
            return !bid.canceled
            
        case .bidderIsNotSeller(let prospect):
            return prospect != auction?.seller
            
        case .buyerIsNotSeller(let prospect):
            return prospect != sale?.seller
            
        case .domainIsOwnedByUsOrOurUser:
            return owner != nil
            
        case .no(let assertion):
            return !check(assertion)

        }
    }
}
