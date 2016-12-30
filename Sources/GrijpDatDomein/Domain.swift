class Domain: Entity {
    let id    : ID
    let url   : URL
    var sale  : Sale?
    var owner : Owner
    
    init(id: ID = ID(), url: URL, sale: Sale? = nil, owner: Owner = .outsider) {
        self.id    = id
        self.url   = url
        self.sale  = sale
        self.owner = owner
    }
}

enum Owner {
    case outsider, us, user(User)
}

func test(user: User, money: Money, domain: Domain) {
    switch domain.sale {
    
    case .order(let order)? where order.status == .cancelled:
        fallthrough

    case .none:
        let order = Order(user: user, domain: domain, price: money)
        domain.sale = .order(order)

    case .order(let order)? where order.status == .active:
        let auction = Auction(domain: domain)
        
        auction.add(Bid(user: order.user, money: order.price))
        auction.add(Bid(user: user, money: money))

        domain.sale = .auction(auction)
        order.status = .cancelled
    
    case .auction(let auction)? where auction.status == .active:
        auction.add(Bid(user: user, money: money))
        
    default: break

    }
}

enum Sale {
    case order(Order), auction(Auction)
}

extension Domain {
    var hasBeenOrdered: Bool {
        switch sale {
            case .order?: return true
            default: return false
        }
    }

    var isBeingAuctioned: Bool {
        switch sale {
            case .auction?: return true
            default: return false
        }
    }

    func isOwned(by owner: Owner) -> Bool {
        switch (owner, self.owner) {
        case let (.user(potentialOwner), .user(realOwner)):
            return potentialOwner == realOwner
        case (.outsider, .outsider), (.us, .us):
            return true
        default:
            return false
        }
    }
}
