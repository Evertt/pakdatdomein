protocol CommandHandler {
    associatedtype AR: AggregateRoot
    associatedtype Command

    static func handle(command: Command, for aggregateRoot: AR!) throws -> AR
}