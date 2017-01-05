public protocol TaskHandler {
    var arType: AggregateRoot.Type { get }
    var cType: Task.Type { get }
    
    @discardableResult
    func handle<AR: AggregateRoot>(task: Task, for aggregateRoot: AR?) throws -> AR
}

struct TypeTaskHandler<AR: AggregateRoot, C: Task>: TaskHandler {
    typealias Handler = (C) throws -> AR
    let handler: Handler
    let cType: Task.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.cType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(task: Task, for aggregateRoot: T?) throws -> T {
        let task = task as! C
        
        return try handler(task) as! T
    }
}

struct InstanceTaskHandler<AR: AggregateRoot, C: Task>: TaskHandler {
    typealias Handler = (AR) -> (C) throws -> Void
    let handler: Handler
    let cType: Task.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.cType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(task: Task, for aggregateRoot: T?) throws -> T {
        let task = task as! C
        let aggregateRoot = aggregateRoot as! AR
        
        try handler(aggregateRoot)(task)
        
        return aggregateRoot as! T
    }
}