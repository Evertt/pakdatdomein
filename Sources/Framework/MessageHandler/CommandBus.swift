public class CommandBus {
    let commandHandlers: [String:TaskHandler]
    let repository: Repository
    
    public init(repository: Repository, aggregateRoots: [AggregateRoot.Type]) {
        var dict = [String:TaskHandler]()
        
        for entity in aggregateRoots {
            dict += entity.handles
        }
        
        self.repository = repository
        commandHandlers = dict
    }
    
    public func send(_ command: Command) throws {
        guard let handler = commandHandlers["\(type(of: command))"] else {
            fatalError()
        }
        
        let aggregateRoot = repository.get(handler.arType, byID: command.id)
        try repository.save(aggregateRoot.handle(command.task, on: handler.arType))
    }
}

func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
