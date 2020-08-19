// sourcery:begin: commands
extension User {
    public static func register(id: ID, name: String, email: String, password: String) throws -> User {
        try ensure(.nameIsValid(name), .emailIsValid(email), .passwordIsValid(password))

        return apply(userRegistered(id: id, name: name, email: email, password: password))
    }
    
    public func changeEmail(newEmail: String) throws {
        try ensure(.emailIsValid(newEmail))

        apply(userChangedEmail(newEmail))
    }
    
    public func changePassword(newPassword: String) throws {
        try ensure(.passwordIsValid(newPassword))

        apply(userChangedPassword(newPassword))
    }
}
