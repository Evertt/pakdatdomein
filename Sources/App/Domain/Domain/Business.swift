enum Business {
    case auction(Auction), sale(Sale)

    var auction: Auction! {
        switch self {
        case let .auction(auction):
            return auction
        default:
            return nil
        }
    }

    var sale: Sale! {
        switch self {
        case let .sale(sale):
            return sale
        default:
            return nil
        }
    }
}