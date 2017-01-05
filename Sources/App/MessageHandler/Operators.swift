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

public prefix func ~<AR: AggregateRoot, C: Task>(handleMethod: @escaping (C) throws -> AR) -> TaskHandler {
    return TypeTaskHandler(handler: handleMethod)
}

public prefix func ~<AR: AggregateRoot, C: Task>(handleMethod: @escaping (AR) -> (C) throws -> Void) -> TaskHandler {
    return InstanceTaskHandler(handler: handleMethod)
}

public func __(_ handlers: TaskHandler...) -> [String:TaskHandler] {
    var dict = [String:TaskHandler]()
    
    for handler in handlers {
        let type = "\(handler.cType)"
        dict[type] = handler
    }
    
    return dict
}