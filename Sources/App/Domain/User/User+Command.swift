extension User {
    enum Command {
        case registerUser(userID: ID, name: String, email: String, password: String)
        case changePassword(newPassword: String)
        case changeEmail(newEmail: String)
    }
}

extension User: CommandHandler {
    static func handle(command: Command, for user: User!) throws -> User {
        switch command {

        case let .registerUser(id, name, email, password):
            return try User.register(id: id, name: name, email: email, password: password)
            
        case let .changePassword(newPassword):
            return try user.change(password: newPassword)
            
        case let .changeEmail(newEmail):
            return try user.change(email: newEmail)

        }
    }
}
