class User: Entity {
    let id: ID
    let name: Name
    var email: Email
    var password: Password
    var active: Bool = true
    
    init?(id: ID = ID(), name: String, email: String, password: String) {
        guard
            let name = Name(name),
            let email = Email(email),
            let password = Password(password) else {
            return nil
        }
        
        self.id       = id
        self.name     = name
        self.email    = email
        self.password = password
    }
}
