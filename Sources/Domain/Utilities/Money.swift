import Foundation

public struct Money {
    public enum Currency: Decimal {
        case usd = 1, eur = 1.05, gbp = 1.22
    }
    
    let amount   : Decimal
    let currency : Currency

    public init(amount: Decimal, currency: Currency) {
        self.amount   = amount
        self.currency = currency
    }
}

extension Money: Comparable {
    public static func ==(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rawValue == right.amount * right.currency.rawValue
    }
    
    public static func <(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rawValue < right.amount * right.currency.rawValue
    }
}
