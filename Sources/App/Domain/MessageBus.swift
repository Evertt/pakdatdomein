enum Command {
    case auction(Auction.Command)
    case sale(Sale.Command)
    case user(User.Command)
}

class MessageBus {    
    var repositories = [String:Any]()

    func execute(command: Command, on aggregateRootID: ID) throws {
        let id = aggregateRootID

        switch command {

        case let .auction(command):
            try execute(command, on: id, with: Auction.self)

        case let .sale(command):
            try execute(command, on: id, with: Sale.self)

        case let .user(command):
            try execute(command, on: id, with: User.self)

        }
    }

    func getRepository<AR: AggregateRoot>() -> AnyRepository<AR> {
        let hash = "\(AR.self)"

        if let repository = repositories[hash] as? AnyRepository<AR> {
            return repository
        }

        let repository     = AnyRepository<AR>()
        repositories[hash] = repository

        return repository
    }

    func execute<CH: CommandHandler>(
        _ command           : CH.Command,
        on aggregateRootID  : ID,
        with commandHandler : CH.Type
    ) throws {
        let repository           = getRepository() as AnyRepository<CH.AR>
        let aggregateRoot        = repository.getAggregateRoot(id: aggregateRootID)
        let updatedAggregateRoot = try CH.handle(command: command, for: aggregateRoot)

        repository.save(updatedAggregateRoot)
    }
}