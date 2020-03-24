public protocol Message: Codable {
    var id: ID { get }
}

public protocol Event: Message {
    var version: Int { get }
}

public protocol Command: Message {}
