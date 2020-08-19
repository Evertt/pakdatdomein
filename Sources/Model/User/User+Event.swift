// sourcery:begin: events
extension User {
    static func userRegistered(id: ID, name: String, email: String, password: String) -> User {
        return User(
            id       : id,
            name     : name,
            email    : email,
            password : password
        )
    }
    
    func userChangedEmail(_ newEmail: String) {
        email = newEmail
    }

    func userChangedPassword(_ newPassword: String) {
        password = newPassword
    }
}
