import XCTest
import Model
@testable import Framework
import GraphZahl

enum HelloWorld: GraphQLSchema {
    typealias ViewerContext = Repository

    class Query: QueryType {
        let repository: Repository

        required init(viewerContext repository: Repository) {
            self.repository = repository
        }

        func domain(domainID: Int) -> Domain {
            return repository.get(Domain.self, byID: ID(domainID)) as! Domain
        }

        func domains() -> [Domain] {
            return repository.get(Domain.self) as! [Domain]
        }
    }

    typealias Mutation = None
}

class DomainTests: XCTestCase {
    static let allTests = [
        ("testDomain", testDomain)
    ]
    
    func testDomain() throws {
        let repository = ARepository()
        let commandBus = CommandBus(repository: repository, aggregateRoots: [Domain.self, User.self])
        
        let user1ID = ID()
        let user2ID = ID()
        let user3ID = ID()

        let domainID = ID()

        let bid1ID = ID()
        let bid2ID = ID()
        
        let url = URL(string: "www.example.com")!
        
        let commands: [Command] = [
            User.Register(id: user1ID, name: "John Doe", email: "john.doe@example.com", password: "secret_password"),
            User.Register(id: user2ID, name: "Jane Doe", email: "jane.doe@example.com", password: "secret_password"),
            User.Register(id: user3ID, name: "Mofo Doe", email: "mofo.doe@example.com", password: "secret_password"),
            
            Domain.CreateFoundDomain(id: domainID, url: url),
            Domain.RequestPurchase(id: domainID, userID: user1ID),
            Domain.GrabDomain(id: domainID),

            Domain.OpenAuction(id: domainID),
            Domain.AddBid(id: domainID, bidID: bid1ID, userID: user2ID, amount: Money(amount: 2, currency: .eur)),
            Domain.AddBid(id: domainID, bidID: bid2ID, userID: user3ID, amount: Money(amount: 5, currency: .eur)),
            Domain.CancelBid(id: domainID, bidID: bid2ID),
            Domain.CompleteAuction(id: domainID),
            Domain.PutOnSale(id: domainID, price: Money(amount: 150, currency: .eur)),
            Domain.RequestPurchase(id: domainID, userID: user3ID),
            Domain.CancelSale(id: domainID),
        ]
        
        do {
            for command in commands {
                try commandBus.send(command)
            }
        } catch {
            print("\n🔴", error)
        }
        
        for event in repository.getEvents() {
            print("\n🟢", event)
        }
        
        let result = try HelloWorld.perform(
            request: #"{ domains { id, url } }"#,
            viewerContext: commandBus.repository
        ).wait()
        
        print("\n🔴", result, "\n")
    }
}

