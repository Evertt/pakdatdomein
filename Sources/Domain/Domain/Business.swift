extension Domain {
    enum Business: AutoCodable {
        case auction(Domain.Auction), sale(Domain.Sale)
        
        var auction: Auction? {
            get {
                switch self {
                case let .auction(auction):
                    return auction
                default:
                    return nil
                }
            }
        }
        
        var sale: Sale? {
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
}
