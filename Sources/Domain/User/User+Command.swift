extension User {
    public struct RegisterUser   : Command { let id: ID, name: String, email: String, password: String }
    public struct ChangePassword : Command { let id: ID, newPassword: String }
    public struct ChangeEmail    : Command { let id: ID, newEmail: String }
}

extension User {
    static let handles = __(~register, ~changePassword, ~changeEmail)

    static func register(command: RegisterUser) throws -> User {
        guard
            let name     = Name(command.name),
            let email    = Email(command.email),
            let password = Password(command.password)
        else {
            throw Error.invalidStuff
        }

        return apply(UserRegistered(id: command.id, version: 1, name: name, email: email, password: password))
    }
    
    func changePassword(command: ChangePassword) throws {
        guard let password = Password(command.newPassword) else {
            throw Error.invalidStuff
        }
        
        apply(PasswordChanged(id: id, version: version, newPassword: password))
    }
    
    func changeEmail(command: ChangeEmail) throws {
        guard let email = Email(command.newEmail) else {
            throw Error.invalidStuff
        }
        
        apply(EmailChanged(id: id, version: version, newEmail: email))
    }
}
