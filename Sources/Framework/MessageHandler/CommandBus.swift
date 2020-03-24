public class CommandBus {
    let commandHandlers: [ObjectIdentifier:CommandHandler]
    var sagaHandlers: [SagaEventBus] = []
    let repository: Repository
    
    public init(repository: Repository, aggregateRoots: [AggregateRoot.Type]) {
        var commandHandlers = [ObjectIdentifier:CommandHandler]()
        var sagaHandlers = [SagaEventBus]()
        
        for entity in aggregateRoots {
            commandHandlers.merge(entity.handles, uniquingKeysWith: {
                current, new in
                return new
            })
        }
        
        self.repository = repository
        self.sagaHandlers = sagaHandlers
        self.commandHandlers = commandHandlers
        
        for entity in aggregateRoots {
            sagaHandlers.append(contentsOf: entity.sagas.map { saga in
                SagaEventBus(commandBus: self, saga: saga)
            })
        }
        
        self.sagaHandlers = sagaHandlers
    }
    
    public func send(_ command: Command) throws {
        guard let handler = commandHandlers[command] else {
            throw Error.noCommandHandlerFound(command: type(of: command))
        }
        
        let aggregateRoot = try repository
            .get(handler.arType, byID: command.id)
            .handle(command, on: handler.arType)
        
        repository.save(aggregateRoot)
        
        for sagaHandler in sagaHandlers {
            try sagaHandler.fireEvents(of: aggregateRoot)
        }
    }
}
