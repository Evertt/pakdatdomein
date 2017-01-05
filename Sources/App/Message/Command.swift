public protocol Task: SaysType {}

public struct Command<Task: App.Task>: Message {
    public let id   : ID
    public let task : Task
}
