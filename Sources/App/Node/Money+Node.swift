import Foundation

extension Money: NodeConvertible {
    init(node: Node, in context: Context) throws {
        let amount   : Double = try node.extract("amount")
        let currency : String = try node.extract("currency")
        
        switch currency {
        case "usd":
            self = Money(amount: Decimal(amount), currency: .usd)
        case "eur":
            self = Money(amount: Decimal(amount), currency: .eur)
        case "gbp":
            self = Money(amount: Decimal(amount), currency: .gbp)
        default:
            throw NodeError.unableToConvert(node: node, expected: "A string with either usd, eur or gbp")
        }
    }
    
    func makeNode(context: Context) throws -> Node {
        let amount = self.amount as NSDecimalNumber
        switch currency {
        case .usd:
            return ["amount": Node(amount.doubleValue), "currency": "usd"]
        case .eur:
            return ["amount": Node(amount.doubleValue), "currency": "eur"]
        case .gbp:
            return ["amount": Node(amount.doubleValue), "currency": "gbp"]
        }
    }
}