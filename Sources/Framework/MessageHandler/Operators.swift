prefix operator ~

public prefix func ~<AR: AggregateRoot, E: Event>(applyMethod: @escaping (E) -> AR) -> EventApplier {
    return TypeEventApplier(applier: applyMethod)
}

public prefix func ~<AR: AggregateRoot, E: Event>(applyMethod: @escaping (AR) -> (E) -> Void) -> EventApplier {
    return InstanceEventApplier(applier: applyMethod)
}

public func __(_ appliers: EventApplier...) -> [String:EventApplier] {
    var dict = [String:EventApplier]()
    
    for applier in appliers {
        let type = "\(applier.type)"
        dict[type] = applier
    }
    
    return dict
}

public prefix func ~<AR: AggregateRoot, C: Command>(handleMethod: @escaping (C) throws -> AR) -> CommandHandler {
    return TypeCommandHandler(handler: handleMethod)
}

public prefix func ~<AR: AggregateRoot, C: Command>(handleMethod: @escaping (AR) -> (C) throws -> Void) -> CommandHandler {
    return InstanceCommandHandler(handler: handleMethod)
}

public func __(_ handlers: CommandHandler...) -> [String:CommandHandler] {
    var dict = [String:CommandHandler]()
    
    for handler in handlers {
        let type = "\(handler.commandType)"
        dict[type] = handler
    }
    
    return dict
}

prefix operator ++
postfix operator ++

prefix func ++<N: Integer>(x: inout N) -> N {
    x = x + 1
    return x
}

postfix func ++<N: Integer>(x: inout N) -> N {
    x = x + 1
    return (x - 1)
}