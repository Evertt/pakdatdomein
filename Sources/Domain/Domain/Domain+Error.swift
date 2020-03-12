extension Domain {
    struct FailedAssertions: Error {
        let assertions: [Assertion]
        
        init(_ assertions: Assertion...) {
            self.assertions = assertions
        }
        
        init(_ assertions: [Assertion] = []) {
            self.assertions = assertions
        }
        
        static func +(lhs: FailedAssertions, rhs: FailedAssertions) -> FailedAssertions {
            return FailedAssertions(lhs.assertions + rhs.assertions)
        }
    }
    
    enum Assertion {
        case noBusinessIsActive
        case saleIsRunning
        case auctionIsRunning
        case bidIsActive(ID)
        case noPendingPurchase
        case purchaseIsPending
        case isOwnedByInsider
        
        fileprivate var failed: Result<Void, FailedAssertions> {
            return .failure(FailedAssertions(self))
        }
    }

    func check(_ assertion: Assertion) -> Result<Void, FailedAssertions> {
        switch assertion {

        case .noBusinessIsActive where business != nil,
             
             .auctionIsRunning where business?.auction == nil,
             
             .saleIsRunning where business?.sale == nil,
             
             .noPendingPurchase where business?.sale?.purchase != nil,
             
             .purchaseIsPending where business?.sale?.purchase == nil,
             
             .isOwnedByInsider where owner == nil:
            
            return assertion.failed
                
        case .bidIsActive(let bidID) where business?.auction?.bids[bidID]?.canceled != false:
            return assertion.failed
            
        default: return .success(())
        }
    }
    
    func check(_ assertion: Assertion) -> Bool {
        return (try? ensure(assertion)) != nil
    }
    
    func ensure(_ assertions: Assertion...) throws {
        let failed = assertions
            .compactMap { assertion in
                check(assertion).getFailure()
            }
            .reduce(FailedAssertions(), +)
        
        if !failed.assertions.isEmpty {
            throw failed
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
