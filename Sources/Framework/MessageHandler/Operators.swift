prefix operator ~

public prefix func ~<AR: AggregateRoot, E: Event>(applyMethod: @escaping (E) -> AR) -> EventApplier {
    return TypeEventApplier(applier: applyMethod)
}

public prefix func ~<AR: AggregateRoot, E: Event>(applyMethod: @escaping (AR) -> (E) -> Void) -> EventApplier {
    return InstanceEventApplier(applier: applyMethod)
}

public func __(_ appliers: EventApplier...) -> [ObjectIdentifier:EventApplier] {
    var dict = [ObjectIdentifier:EventApplier]()
    
    for applier in appliers {
        dict[applier.eventType] = applier
    }
    
    return dict
}

public prefix func ~<AR: AggregateRoot, C: Command>(handleMethod: @escaping (C) throws -> AR) -> CommandHandler {
    return TypeCommandHandler(handler: handleMethod)
}

public prefix func ~<AR: AggregateRoot, C: Command>(handleMethod: @escaping (AR) -> (C) throws -> Void) -> CommandHandler {
    return InstanceCommandHandler(handler: handleMethod)
}

public func __(_ handlers: CommandHandler...) -> [ObjectIdentifier:CommandHandler] {
    var dict = [ObjectIdentifier:CommandHandler]()
    
    for handler in handlers {
        dict[handler.commandType] = handler
    }
    
    return dict
}
