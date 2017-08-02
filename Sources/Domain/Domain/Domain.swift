public final class Domain: AggregateRoot {
    public let id: ID
    let url      : URL
    var owner    : Owner?
    var business : Business?

    public var version: Int
    public var uncommittedEvents = [Event]()

    var sale: Sale! {
        get { return business?.sale      }
        set { business = .sale(newValue) }
    }

    var auction: Auction! {
        get { return business?.auction      }
        set { business = .auction(newValue) }
    }
    
    init(id: ID, url: URL, owner: Owner?, version: Int) {
        self.id      = id
        self.url     = url
        self.owner   = owner
        self.version = version
    }
}


extension Domain: CustomDebugStringConvertible {
    public var debugDescription: String {
        let dict: [String:Any] = [
            "id": id,
            "url": url,
            "owner": owner as Any,
            "business": business as Any
        ]
        
        return "\(dict)"
    }
}
