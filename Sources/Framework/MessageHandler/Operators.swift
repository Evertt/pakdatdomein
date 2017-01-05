prefix operator ~

public prefix func ~<AR: AggregateRoot, E: Fact>(applyMethod: @escaping (E) -> AR) -> FactApplier {
    return TypeFactApplier(applier: applyMethod)
}

public prefix func ~<AR: AggregateRoot, E: Fact>(applyMethod: @escaping (AR) -> (E) -> Void) -> FactApplier {
    return InstanceFactApplier(applier: applyMethod)
}

public func __(_ appliers: FactApplier...) -> [String:FactApplier] {
    var dict = [String:FactApplier]()
    
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
        let type = "\(handler.taskType)"
        dict[type] = handler
    }
    
    return dict
}
