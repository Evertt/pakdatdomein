extension User {
    public struct Register: Command {
        public let id: ID
        let name: String
        let email: String
        let password: String
        
        public init(id: ID, name: String, email: String, password: String) {
            self.id       = id
            self.name     = name
            self.email    = email
            self.password = password
        }
    }
    
    public struct ChangeEmail: Command {
        public let id: ID
        let newEmail: String
        
        public init(id: ID, newEmail: String) {
            self.id       = id
            self.newEmail = newEmail
        }
    }
    
    public struct ChangePassword: Command {
        public let id: ID
        let newPassword: String
        
        public init(id: ID, newPassword: String) {
            self.id          = id
            self.newPassword = newPassword
        }
    }
}

extension User {
    static func register(command: Register) throws -> User {
        guard
            let name     = Name(command.name),
            let email    = Email(command.email),
            let password = Password(command.password)
        else {
            throw Error.invalidStuff
        }

        return apply(Registered(id: command.id, version: 1, name: name, email: email, password: password))
    }
    
    func changeEmail(command: ChangeEmail) throws {
        guard let email = Email(command.newEmail) else {
            throw Error.invalidStuff
        }
        
        apply(EmailChanged(id: id, version: version, newEmail: email))
    }
    
    func changePassword(command: ChangePassword) throws {
        guard let password = Password(command.newPassword) else {
            throw Error.invalidStuff
        }
        
        apply(PasswordChanged(id: id, version: version, newPassword: password))
    }
}

extension User {
    public static let handles = __(
        ~register,
        ~changeEmail,
        ~changePassword
    )
}
