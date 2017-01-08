public class CommandBus {
    let commandHandlers: [String:CommandHandler]
    let repository: Repository
    
    public init(repository: Repository, aggregateRoots: [AggregateRoot.Type]) {
        var dict = [String:CommandHandler]()
        
        for entity in aggregateRoots {
            dict += entity.handles
        }
        
        self.repository = repository
        commandHandlers = dict
    }
    
    public func send(_ command: Command) throws {
        let commandType = "\(type(of: command))"
        
        guard let handler = commandHandlers[commandType] else {
            fatalError()
        }
        
        let aggregateRoot = repository.get(handler.arType, byID: command.id)
        try repository.save(aggregateRoot.handle(command, on: handler.arType))
    }
}

func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
