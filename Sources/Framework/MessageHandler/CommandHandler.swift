public protocol CommandHandler {
    var arType: AggregateRoot.Type { get }
    var commandType: Command.Type { get }
    
    @discardableResult
    func handle<AR: AggregateRoot>(command: Command, for aggregateRoot: AR?) throws -> AR
}

struct TypeCommandHandler<AR: AggregateRoot, C: Command>: CommandHandler {
    typealias Handler = (C) throws -> AR
    let handler: Handler
    let commandType: Command.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.commandType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(command: Command, for aggregateRoot: T?) throws -> T {
        guard aggregateRoot is AR? else {
            throw Error.aggregateRootNotRightType(expected: AR.self, got: T.self)
        }
        
        guard let cCommand = command as? C else {
            throw Error.commandNotRightType(expected: C.self, got: type(of: command))
        }
        
        return try handler(cCommand) as! T
    }
}

struct InstanceCommandHandler<AR: AggregateRoot, C: Command>: CommandHandler {
    typealias Handler = (AR) -> (C) throws -> Void
    let handler: Handler
    let commandType: Command.Type
    let arType: AggregateRoot.Type
    
    init(handler: @escaping Handler) {
        self.handler = handler
        self.commandType = C.self
        self.arType = AR.self
    }
    
    func handle<T: AggregateRoot>(command: Command, for aggregateRoot: T?) throws -> T {
        guard let ar = aggregateRoot as? AR else {
            throw Error.aggregateRootNotRightType(expected: AR.self, got: T.self)
        }
        
        guard let cCommand = command as? C else {
            throw Error.commandNotRightType(expected: C.self, got: type(of: command))
        }
        
        try handler(ar)(cCommand)
        
        return ar as! T
    }
}
