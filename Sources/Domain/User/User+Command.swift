// sourcery:begin: commands
extension User {
    public static func register(id: ID, name: String, email: String, password: String) throws -> User {
        let name     = try Name(name)
        let email    = try Email(email)
        let password = try Password(password)

        return apply(UserRegistered(id: id, version: 1, name: name, email: email, password: password))
    }
    
    public func changeEmail(newEmail: String) throws {
        let email = try Email(newEmail)
        
        apply(UserChangedEmail(id: id, version: version, newEmail: email))
    }
    
    public func changePassword(newPassword: String) throws {
        let password = try Password(newPassword)
        
        apply(UserChangedPassword(id: id, version: version, newPassword: password))
    }
}
