struct Money {
    enum Currency: Decimal {
        case usd = 1, eur = 1.05, gbp = 1.22
    }
    
    let currency: Currency
    let amount: Decimal
}

extension Money: Comparable {
    static func ==(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rawValue == right.amount * right.currency.rawValue
    }
    
    static func <(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rawValue < right.amount * right.currency.rawValue
    }
}
