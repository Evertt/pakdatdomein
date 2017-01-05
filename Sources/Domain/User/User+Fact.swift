extension User {
    struct UserRegistered  : Fact { let id: ID, name: Name, email: Email, password: Password }
    struct PasswordChanged : Fact { let newPassword: Password }
    struct EmailChanged    : Fact { let newEmail: Email }
}

extension User {
    static let applies = __(~userRegistered, ~passwordChanged, ~emailChanged)

    static func userRegistered(fact: UserRegistered) -> User {
        return User(
            id       : fact.id,
            name     : fact.name,
            email    : fact.email,
            password : fact.password
        )
    }

    func passwordChanged(fact: PasswordChanged) {
        password = fact.newPassword
    }

    func emailChanged(fact: EmailChanged) {
        email = fact.newEmail
    }
}