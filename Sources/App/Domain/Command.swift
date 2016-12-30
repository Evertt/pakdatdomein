enum UserCommand {
    case registerUser(userID: ID, name: String, email: String, password: String)
    case changePassword(userID: ID, newPassword: String)
}

class UserCommandHandler {
    typealias UserRepository = AnyRepository<User>
    let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func handle(command: UserCommand) throws {
        switch command {

        case let .registerUser(userID, name, email, password):
            let user = try User.register(id: userID, name: name, email: email, password: password)
            repository.save(aggregateRoot: user)
            
        case let .changePassword(userID, _):
            let user = repository.getAggregateRoot(id: userID)
            //user.change(password: newPassword)
            repository.save(aggregateRoot: user)

        }
    }
}