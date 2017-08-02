public class CommandBus {
    let commandHandlers: [String:CommandHandler]
    let repository: Repository
    
    public init(repository: Repository, aggregateRoots: [AggregateRoot.Type]) {
        var handlers = [String:CommandHandler]()
        
        for entity in aggregateRoots {
            handlers.merge(dictionaries: entity.handles)
        }
        
        self.repository = repository
        commandHandlers = handlers
    }
    
    public func send(_ command: Command) throws {
        let commandType = command.type
        
        guard let handler = commandHandlers[commandType] else {
            fatalError()
        }
        
        let aggregateRoot = repository.get(handler.arType, byID: command.id)
        try repository.save(aggregateRoot.handle(command, on: handler.arType))
    }
}
