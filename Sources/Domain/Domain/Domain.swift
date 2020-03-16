public final class Domain: AggregateRoot {
    public let id: ID
    let url      : URL
    var owner    : Owner?
    var business : Business?

    public var version: Int = 0
    public var uncommittedEvents = [Event]()

    var sale: Sale! {
        get { return business?.sale      }
        set { business = .sale(newValue) }
    }

    var auction: Auction! {
        get { return business?.auction      }
        set { business = .auction(newValue) }
    }
    
    init(id: ID, version: Int = 1, url: URL, owner: Owner?) {
        self.id      = id
        self.version = version

        self.url     = url
        self.owner   = owner
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
