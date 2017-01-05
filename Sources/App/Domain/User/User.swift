final class User {
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

        return apply(event: .userRegistered(id: id, name: name, email: email, password: password))
    }
    
    func change(password: String) throws -> User {
        guard let password = Password(password) else {
            throw Error.invalidStuff
        }
        
        return apply(event: .passwordChanged(newPassword: password))
    }
    
    func change(email: String) throws -> User {
        guard let email = Email(email) else {
            throw Error.invalidStuff
        }
        
        return apply(event: .emailChanged(newEmail: email))
    }
    
    static func apply<U>(event: Event) -> U {
        fatalError()
    }
    
    func apply<U>(event: Event) -> U {
        fatalError()
    }
    
    static func apply(event: Event) {
        fatalError()
    }
    
    func apply(event: Event) {
        fatalError()
    }
}

extension User {
    enum Error: Swift.Error {
        case invalidStuff
    }
}
