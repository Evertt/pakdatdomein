extension User {
    struct RegisterUser   : Task { let id: ID, name: String, email: String, password: String }
    struct ChangePassword : Task { let newPassword: String }
    struct ChangeEmail    : Task { let newEmail: String }
}

extension User {
    static let handles = __(~register, ~changePassword, ~changeEmail)

    static func register(task: RegisterUser) throws -> User {
        guard
            let name     = Name(task.name),
            let email    = Email(task.email),
            let password = Password(task.password)
        else {
            throw Error.invalidStuff
        }

        return apply(UserRegistered(id: task.id, name: name, email: email, password: password))
    }
    
    func changePassword(task: ChangePassword) throws {
        guard let password = Password(task.newPassword) else {
            throw Error.invalidStuff
        }
        
        apply(PasswordChanged(newPassword: password))
    }
    
    func changeEmail(task: ChangeEmail) throws {
        guard let email = Email(task.newEmail) else {
            throw Error.invalidStuff
        }
        
        apply(EmailChanged(newEmail: email))
    }
}
