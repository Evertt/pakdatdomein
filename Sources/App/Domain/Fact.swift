struct Fact<Event: App.Event> {
    let aggregateRootID : ID
    let version         : Int
    let event           : Event
}