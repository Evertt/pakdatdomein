public final class Domain: AggregateRoot {
    public let id: ID
    let url      : URL
    var owner    : Owner?
    var business : Business?

    public var version = 0
    public var uncommittedEvents = [Event]()

    var sale: Sale! {
        get { return business?.sale      }
        set { business = .sale(newValue) }
    }

    var auction: Auction! {
        get { return business?.auction      }
        set { business = .auction(newValue) }
    }
    
    init(id: ID, url: URL, owner: Owner?) {
        self.id    = id
        self.url   = url
        self.owner = owner
    }
}


extension Domain: CustomDebugStringConvertible {
    public var debugDescription: String {
        let dict: [String:Any] = ["id": id, "url": url, "owner": (owner ?? nil) as Any, "business": (business ?? nil) as Any]
        return "\(dict)"
    }
}
