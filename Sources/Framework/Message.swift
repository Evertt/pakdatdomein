public protocol SaysType {}

extension SaysType {
    var type: String { return "\(Self.self)" }
    static var type: String { return "\(Self.self)" }
}

public protocol Message: SaysType, Codable {
    var id: ID { get }
}

public protocol Event: Message {
    var version: Int { get }
}

public protocol Command: Message {}
