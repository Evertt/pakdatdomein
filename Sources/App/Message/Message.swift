public protocol SaysType {}

public protocol Message: SaysType {
    var id: ID { get }
}

extension SaysType {
    var type: String {
        return "\(Self.self)"
    }
}
