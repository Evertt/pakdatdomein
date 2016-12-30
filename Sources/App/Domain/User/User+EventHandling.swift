extension User {
    static func apply(event: Event, to user: User!) -> User {
        switch event {
        
        case let .userRegistered(id, name, email, password):
            return User(id: id, name: name, email: email, password: password)
            
        case let .userChangedPassword(newPassword):
            user.password = newPassword
        
        case let .userChangedEmail(newEmail):
            user.email = newEmail

        }
        
        return user
    }
}