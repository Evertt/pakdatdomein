extension User {
    enum Event {
        case userRegistered(id: ID, name: Name, email: Email, password: Password)
        case passwordChanged(newPassword: Password)
        case emailChanged(newEmail: Email)
    }
}

extension User {
    static func apply(event: Event, to user: User!) -> User {
        switch event {
        
        case let .userRegistered(id, name, email, password):
            return User(id: id, name: name, email: email, password: password)
            
        case let .passwordChanged(newPassword):
            user.password = newPassword
        
        case let .emailChanged(newEmail):
            user.email = newEmail

        }
        
        return user
    }
}
