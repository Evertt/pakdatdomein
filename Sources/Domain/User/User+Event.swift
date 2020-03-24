// sourcery:begin: events
extension User {
    static func userRegistered(id: ID, name: Name, email: Email, password: Password) -> User {
        return User(
            id       : id,
            name     : name,
            email    : email,
            password : password
        )
    }
    
    func userChangedEmail(newEmail: Email) {
        email = newEmail
    }

    func userChangedPassword(newPassword: Password) {
        password = newPassword
    }
}
