extension User {
    enum Event {
        case userRegistered(id: ID, name: Name, email: Email, password: Password)
        case userChangedPassword(newPassword: Password)
        case userChangedEmail(newEmail: Email)
    }
}