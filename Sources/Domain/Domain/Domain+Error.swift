extension Domain {
    /// These are all the things that can go wrong in this app
    
    enum Assertion: Equatable {
        case noBusinessIsActive
        case saleIsRunning
        case auctionIsRunning
        case bidIsActive(_ bidID: ID)
        case noPendingPurchase
        case purchaseIsPending
        case isOwnedByInsider
        case bidderIsNotOwner(_ bidderID: ID)
        case buyerIsNotOwner(_ buyerID: ID)
        
        fileprivate var failed: AssertionResult {
            return .failure(FailedAssertions([self]))
        }
        
        fileprivate var succeeded: AssertionResult {
            return .success(())
        }
    }
}

extension Domain {
    /// If assertions go wrong, we store those failed assertions in this type.
    /// We do this so we can check multiple assertions at a time
    /// and throw one error with all the failed assertions.
    
    typealias FailedAssertions = Array<Assertion>
    typealias AssertionResult = Result<Void, FailedAssertions>
}

extension Array: Error where Element == Domain.Assertion {}

extension Domain {
    func check(_ assertion: Assertion) -> AssertionResult {
        switch assertion {

        case .noBusinessIsActive where business != nil,
             
             .auctionIsRunning where business?.auction == nil,
             
             .saleIsRunning where business?.sale == nil,
             
             .noPendingPurchase where business?.sale?.purchase != nil,
             
             .purchaseIsPending where business?.sale?.purchase == nil,
             
             .isOwnedByInsider where owner == nil:
            
            return assertion.failed
                
        case let .bidIsActive(bidID) where business?.auction?.bids[bidID]?.canceled != false:
            return assertion.failed
            
        case let .bidderIsNotOwner(bidder) where bidder == auction.owner:
            return assertion.failed
            
        case let .buyerIsNotOwner(buyer) where buyer == sale.owner:
            return assertion.failed
            
        default: return assertion.succeeded
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
            // throw failedAssertions
        }
    }
}

extension Result {
    func getFailure() -> Failure? {
        if case .failure(let failure) = self {
            return failure
        }
        
        return nil
    }
}
