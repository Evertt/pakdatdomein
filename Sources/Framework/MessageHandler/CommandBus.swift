public class CommandBus {
    let commandHandlers: [String:CommandHandler]
    var sagaHandlers: [SagaEventBus] = []
    let repository: Repository
    
    public init(repository: Repository, aggregateRoots: [AggregateRoot.Type]) {
        var commandHandlers = [String:CommandHandler]()
        var sagaHandlers = [SagaEventBus]()
        
        for entity in aggregateRoots {
            commandHandlers.merge(entity.handles) { $1 }
        }
        
        self.repository = repository
        self.sagaHandlers = sagaHandlers
        self.commandHandlers = commandHandlers
        
        for entity in aggregateRoots {
            sagaHandlers.append(contentsOf: entity.sagas.map {
                SagaEventBus(commandBus: self, saga: $0)
            })
        }
        
        self.sagaHandlers = sagaHandlers
    }
    
    public func send(_ command: Command) throws {
        let commandType = command.type
        
        guard let handler = commandHandlers[commandType] else {
            throw Error.noCommandHandlerFound(command: type(of: command))
        }
        
        let aggregateRoot = try repository
            .get(handler.arType, byID: command.id)
            .handle(command, on: handler.arType)
        
        repository.save(aggregateRoot)
        
        for sagaHandler in sagaHandlers {
            try sagaHandler.fireEvents(of: aggregateRoot)
        }
        
        aggregateRoot.uncommittedEvents = []
    }
}
