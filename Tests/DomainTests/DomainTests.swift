import XCTest
import Domain
import Framework

class DomainTests: XCTestCase {
    static let allTests = [
        ("testDomain", testDomain)
    ]
    
    func testDomain() throws {
        let repository = ARepository()
        let commandBus = CommandBus(repository: repository, aggregateRoots: [Domain.self])
        
        let domainID = ID()
        let user1ID = ID()
        let user2ID = ID()
        let bid1ID = ID()
        let bid2ID = ID()
        
        let url = URL(string: "www.google.nl")!
        
        let tasks: [Task] = [
            Domain.FindDomain(id: domainID, url: url),
            Domain.OpenAuction(),
            Domain.AddBid(bidID: bid1ID, userID: user1ID, amount: Money(amount: 2, currency: .eur)),
            Domain.AddBid(bidID: bid2ID, userID: user2ID, amount: Money(amount: 5, currency: .eur))
        ]
        
        for task in tasks {
            try commandBus.send(task, to: domainID)
        }
        
        print("🔴", repository.getEvents(byID: domainID))
    }
}
