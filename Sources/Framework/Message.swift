public protocol SaysType {}

public protocol Message: SaysType {
    var id: ID { get }
}

extension SaysType {
    var type: String { return "\(Self.self)" }
    static var type: String { return "\(Self.self)" }
}

public protocol Event: Message {
    var version: Int { get }
}

public protocol Command: Message {}