import Foundation

public struct Money: Codable {
    public enum Currency: String, Codable {
        case usd, eur, gbp
    }
    
    let amount   : Decimal
    let currency : Currency

    public init(amount: Decimal, currency: Currency) {
        self.amount   = amount
        self.currency = currency
    }
}

extension Money.Currency {
    var rate: Decimal {
        switch self {
        case .usd: return 1
        case .eur: return 1.17
        case .gbp: return 1.12
        }
    }
}

extension Money: Comparable {
    public static func ==(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rate == right.amount * right.currency.rate
    }
    
    public static func <(left: Money, right: Money) -> Bool {
        return left.amount * left.currency.rate < right.amount * right.currency.rate
    }
}
