extension User {
    enum Command {
        case registerUser(userID: ID, name: String, email: String, password: String)
        case changePassword(newPassword: String)
        case changeEmail(newEmail: String)
    }
}

extension User: CommandHandler {
    static func handle(command: Command, for user: User!) throws -> [Event] {
        switch command {

        case let .registerUser(id, name, email, password):
            let user = try User.register(id: id, name: name, email: email, password: password)
            return user.uncommittedEvents
            
        case let .changePassword(newPassword):
            try user.change(password: newPassword)
            
        case let .changeEmail(newEmail):
            try user.change(email: newEmail)

        }

        return user.uncommittedEvents
    }
}
