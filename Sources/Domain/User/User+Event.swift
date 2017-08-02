extension User {
    public struct Registered      : Event { public let id: ID, version: Int, name: Name, email: Email, password: Password }
    public struct EmailChanged    : Event { public let id: ID, version: Int, newEmail: Email }
    public struct PasswordChanged : Event { public let id: ID, version: Int, newPassword: Password }
}

extension User {
    static func registered(event: Registered) -> User {
        return User(
            id       : event.id,
            version  : event.version,

            name     : event.name,
            email    : event.email,
            password : event.password
        )
    }
    
    func emailChanged(event: EmailChanged) {
        email = event.newEmail
    }

    func passwordChanged(event: PasswordChanged) {
        password = event.newPassword
    }
}

extension User {
    public static let applies = __(
        ~registered,
        ~emailChanged,
        ~passwordChanged
    )
}
