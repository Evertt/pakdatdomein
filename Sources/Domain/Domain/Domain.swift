final class Domain: AggregateRoot {
    let id       : ID
    let url      : URL
    var owner    : Owner!
    var business : Business!

    var version = 0
    var uncommittedFacts = [Fact]()

    var sale: Sale! {
        get { return business.sale     }
        set { business.sale = newValue }
    }

    var auction: Auction! {
        get { return business.auction     }
        set { business.auction = newValue }
    }
    
    init(id: ID, url: URL, owner: Owner?) {
        self.id    = id
        self.url   = url
        self.owner = owner
    }
}
