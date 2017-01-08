public protocol Event: Message {
    var version: Int { get }
}