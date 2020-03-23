extension Domain {
    /// These are all the things that can go wrong in this app
    
    enum Assertion: Equatable, Error {
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
}

extension Domain {
    func check(_ assertion: Assertion) -> AssertionResult {
        switch assertion {

        case .noBusinessIsActive where business != nil,
             
             .saleIsRunning where business?.sale == nil,
             .auctionIsRunning where business?.auction == nil,
             
             .purchaseIsPending where business?.sale?.purchase == nil,
             .noPurchaseIsPending where business?.sale?.purchase != nil,
             
             .domainIsOwnedByUsOrOurUser where owner == nil:
            
            return assertion.failed
                
        case let .bidIsActive(bidID) where business?.auction?.bids[bidID]?.canceled != false:
            return assertion.failed
            
        case let .bidderIsNotSeller(bidder) where bidder == auction.seller:
            return assertion.failed
            
        case let .buyerIsNotSeller(buyer) where buyer == sale.seller:
            return assertion.failed
            
        default:
            return assertion.succeeded
        }
    }
    
    func check(_ assertion: Assertion) -> Bool {
        if case .success = check(assertion) as AssertionResult {
            return true
        } else {
            return false
        }
    }
    
    func ensure(_ assertions: Assertion...) throws {
        let failedAssertions = assertions
            .compactMap { assertion in
                check(assertion).getFailure()
            }
        
        if !failedAssertions.isEmpty {
            throw failedAssertions
        }
    }
}

extension Domain {
    typealias FailedAssertion = Domain.Assertion
    typealias FailedAssertions = [FailedAssertion]
    typealias AssertionResult = Result<Void, FailedAssertions>
}

extension Domain.Assertion {
    fileprivate var failed: Domain.AssertionResult {
        return .failure([self])
    }
    
    fileprivate var succeeded: Domain.AssertionResult {
        return .success(())
    }
}
