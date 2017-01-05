public protocol Fact: SaysType {}

public struct Event: Message {
    public let id      : ID
    public let version : Int
    public let fact    : Fact
}
