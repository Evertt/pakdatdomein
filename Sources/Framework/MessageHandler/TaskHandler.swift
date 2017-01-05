public protocol TaskHandler {
    var arType: AggregateRoot.Type { get }
    var taskType: Task.Type { get }
    
    @discardableResult
    func handle<AR: AggregateRoot>(task: Task, for aggregateRoot: AR?) throws -> AR
}

struct TypeTaskHandler<AR: AggregateRoot, C: Task>: TaskHandler {
    typealias Handler = (C) throws -> AR
    let handler: Handler
    let taskType: Task.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.taskType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(task: Task, for aggregateRoot: T?) throws -> T {
        guard aggregateRoot is AR? else {
            throw Error.aggregateRootNotRightType(expected: AR.self, got: T.self)
        }
        
        guard let cTask = task as? C else {
            throw Error.taskNotRightType(expected: C.self, got: type(of: task))
        }
        
        return try handler(cTask) as! T
    }
}

struct InstanceTaskHandler<AR: AggregateRoot, C: Task>: TaskHandler {
    typealias Handler = (AR) -> (C) throws -> Void
    let handler: Handler
    let taskType: Task.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.taskType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(task: Task, for aggregateRoot: T?) throws -> T {
        guard let ar = aggregateRoot as? AR else {
            throw Error.aggregateRootNotRightType(expected: AR.self, got: T.self)
        }
        
        guard let cTask = task as? C else {
            throw Error.taskNotRightType(expected: C.self, got: type(of: task))
        }
        
        try handler(ar)(cTask)
        
        return ar as! T
    }
}
