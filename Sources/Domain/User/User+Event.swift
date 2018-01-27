extension User {
    public struct UserRegistered      : Event { public let id: ID, version: Int, name: Name, email: Email, password: Password }
    public struct UserChangedEmail    : Event { public let id: ID, version: Int, newEmail: Email }
    public struct UserChangedPassword : Event { public let id: ID, version: Int, newPassword: Password }
}

extension User {
    static func userRegistered(event: UserRegistered) -> User {
        return User(
            id       : event.id,
            version  : event.version,

            name     : event.name,
            email    : event.email,
            password : event.password
        )
    }
    
    func userChangedEmail(event: UserChangedEmail) {
        email = event.newEmail
    }

    func userChangedPassword(event: UserChangedPassword) {
        password = event.newPassword
    }
}

extension User {
    public static let applies = __(
        ~userRegistered,
        ~userChangedEmail,
        ~userChangedPassword
    )
}
