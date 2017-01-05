public protocol Task: SaysType {}

public struct Command: Message {
    public let id   : ID
    public let task : Task
}
