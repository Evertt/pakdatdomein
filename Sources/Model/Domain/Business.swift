extension Domain {
    enum Business: AutoCodable {
        case auction(Domain.Auction)
        case sale(Domain.Sale)
    }
}

extension Domain.Business {
    var auction: Domain.Auction? {
        get {
            switch self {
            case let .auction(auction):
                return auction
            default:
                return nil
            }
        }
    }
    
    var sale: Domain.Sale? {
        get {
            switch self {
            case let .sale(sale):
                return sale
            default:
                return nil
            }
        }
    }
}
