final class User: AggregateRoot {
    let id: ID
    let name: Name
    var email: Email
    var password: Password
    var active: Bool = true
    
    var version = 0
    var uncommittedFacts = [Fact]()

    init(id: ID, name: Name, email: Email, password: Password) {
        self.id       = id
        self.name     = name
        self.email    = email
        self.password = password
    }
}

extension User {
    enum Error: Swift.Error {
        case invalidStuff
    }
}
