final class User: AggregateRoot {
    let id: ID
    let name: Name
    var email: Email
    var password: Password
    var active: Bool = true

    init(id: ID = ID(), name: Name, email: Email, password: Password) {
        self.id       = id
        self.name     = name
        self.email    = email
        self.password = password
    }

    static func register(id: ID, name: String, email: String, password: String) throws -> User {
        guard
            let name     = Name(name),
            let email    = Email(email),
            let password = Password(password)
        else {
            throw Error.invalidStuff
        }

        return apply(event: .userRegistered(id: id, name: name, email: email, password: password))
    }
}

extension User {
    enum Error: Swift.Error {
        case invalidStuff
    }
}