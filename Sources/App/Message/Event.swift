public protocol Event: SaysType {}

public protocol CreationEvent: Event {}

public struct Fact<Event: App.Event>: Message {
    public let id      : ID
    public let version : Int
    public let event   : Event
}
