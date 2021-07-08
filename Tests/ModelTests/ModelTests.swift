import XCTest
import Model
@testable import Framework

class DomainTests: XCTestCase {
    static let allTests = [
        ("testDomain", testDomain)
    ]
    
    func testDomain() throws {
        let repository = ARepository()
        let commandBus = CommandBus(repository: repository, aggregateRoots: [Domain.self, User.self])
        
        let johnID = ID()
        let janeID = ID()
        let jayID = ID()

        let domainID = ID()

        let janesBidID = ID()
        let johnsBidID = ID()
        
        let url = URL(string: "www.example.com")!
        
        let commands: [Command] = [
            // Register some users
            User.Register(id: johnID, name: "John Doe", email: "john.doe@example.com", password: "secret_password"),
            User.Register(id: janeID, name: "Jane Doe", email: "jane.doe@example.com", password: "secret_password"),
            User.Register(id: jayID, name: "Jay Doe", email: "jay.doe@example.com", password: "secret_password"),
            
            // Say that we a found domain
            Domain.CreateFoundDomain(id: domainID, url: url),
            // A user should be able to request to purchase the found domain,
            // for if we will be able to grab it
            Domain.RequestPurchase(id: domainID, userID: johnID),
            // And then let's say that we were able to grab the domain,
            // then the FoundDomainSaga should automatically complete the user's purchase
            Domain.GrabDomain(id: domainID),

            Domain.OpenAuction(id: domainID),
            Domain.AddBid(id: domainID, bidID: janesBidID, userID: janeID, amount: 2.euro),
            Domain.AddBid(id: domainID, bidID: johnsBidID, userID: jayID, amount: 5.euro),
            Domain.CancelBid(id: domainID, bidID: johnsBidID),
            Domain.CompleteAuction(id: domainID),
            
            Domain.PutOnSale(id: domainID, price: Money(amount: 150, currency: .eur)),
            Domain.RequestPurchase(id: domainID, userID: jayID),
            Domain.CancelSale(id: domainID),
        ]
        
        do {
            for command in commands {
                try commandBus.send(command)
            }
        } catch {
            print("\n🔴", error)
        }
        
        let expectedEvents: [Event] = [
            // These events are just expected as a direct result from our commands
            User.UserRegistered(id: johnID, version: 1, name: "John Doe", email: "john.doe@example.com", password: "secret_password"),
            User.UserRegistered(id: janeID, version: 1, name: "Jane Doe", email: "jane.doe@example.com", password: "secret_password"),
            User.UserRegistered(id: jayID, version: 1, name: "Jay Doe", email: "jay.doe@example.com", password: "secret_password"),
            Domain.DomainFound(id: domainID, version: 1, url: url),
            
            // These events prove that the FoundDomainSaga works correctly
            Domain.SaleOpened(id: domainID, version: 2, seller: .us, price: Default.priceOfDomain),
            Domain.PurchaseRequested(id: domainID, version: 3, userID: johnID),
            Domain.DomainGrabbed(id: domainID, version: 4),
            Domain.PurchaseCompleted(id: domainID, version: 5),
            Domain.DomainChangedOwner(id: domainID, version: 6, newOwner: .user(userID: johnID)),
            
            // Again, these events are just expected as a direct result from our commands
            Domain.AuctionOpened(id: domainID, version: 7, seller: .user(userID: johnID), start: .now, end: .now + 10.days),
            Domain.BidAdded(id: domainID, version: 8, bidID: janesBidID, userID: janeID, amount: 2.euro),
            Domain.BidAdded(id: domainID, version: 9, bidID: johnsBidID, userID: jayID, amount: 5.euro),
            Domain.BidCanceled(id: domainID, version: 10, bidID: johnsBidID),
            Domain.AuctionCompleted(id: domainID, version: 11),
            // Since John canceled his bid, we expect Jane to get the domain, even though the bid lower
            Domain.DomainChangedOwner(id: domainID, version: 12, newOwner: .user(userID: janeID)),
            
            Domain.SaleOpened(id: domainID, version: 13, seller: .user(userID: janeID), price: 150.euro),
            Domain.PurchaseRequested(id: domainID, version: 14, userID: jayID),
            // If a sale is canceled, then the purchase should be canceled too
            Domain.PurchaseCanceled(id: domainID, version: 15),
            Domain.SaleCanceled(id: domainID, version: 16)
        ]
        
        let actualEvents = repository.getEvents()
        
        for (i, event) in expectedEvents.enumerated() {
            XCTAssert("\(event)" == "\(actualEvents[i])")
        }
    }
}

