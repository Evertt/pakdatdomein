extension User {
    public struct UserRegistered  : Event { public let id: ID, version: Int, name: Name, email: Email, password: Password }
    public struct PasswordChanged : Event { public let id: ID, version: Int, newPassword: Password }
    public struct EmailChanged    : Event { public let id: ID, version: Int, newEmail: Email }
}

extension User {
    static let applies = __(~userRegistered, ~passwordChanged, ~emailChanged)

    static func userRegistered(event: UserRegistered) -> User {
        return User(
            id       : event.id,
            name     : event.name,
            email    : event.email,
            password : event.password
        )
    }

    func passwordChanged(event: PasswordChanged) {
        password = event.newPassword
    }

    func emailChanged(event: EmailChanged) {
        email = event.newEmail
    }
}