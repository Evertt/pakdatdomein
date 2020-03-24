public final class User: AggregateRoot {
    public let id : ID
    let name      : Name
    var email     : Email
    var password  : Password
    var active    : Bool = true
    
    public var version: Int = 0
    public var uncommittedEvents = [Event]()

    init(id: ID, version: Int = 1, name: Name, email: Email, password: Password) {
        self.id       = id
        self.version  = version

        self.name     = name
        self.email    = email
        self.password = password
    }
    
    public static let sagas: [Saga.Type] = []
}
