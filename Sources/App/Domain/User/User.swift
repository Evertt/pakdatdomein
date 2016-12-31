final class User: AggregateRoot {
    let id: ID
    let name: Name
    var email: Email
    var password: Password
    var active: Bool = true
    
    var uncommittedEvents = [Event]()

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

        return fire(event: .userRegistered(id: id, name: name, email: email, password: password))
    }
    
    func change(password: String) throws {
        guard let password = Password(password) else {
            throw Error.invalidStuff
        }
        
        fire(event: .passwordChanged(newPassword: password))
    }
    
    func change(email: String) throws {
        guard let email = Email(email) else {
            throw Error.invalidStuff
        }
        
        fire(event: .emailChanged(newEmail: email))
    }
}

extension User {
    enum Error: Swift.Error {
        case invalidStuff
    }
}
