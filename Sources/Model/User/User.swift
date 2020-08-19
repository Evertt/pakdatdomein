public final class User: AggregateRoot {
    public let id : ID
    let name      : String
    var email     : String
    var password  : String
    var active    : Bool = true
    
    public var version: Int = 0
    public var uncommittedEvents = [Event]()

    init(id: ID, version: Int = 1, name: String, email: String, password: String) {
        self.id       = id
        self.version  = version

        self.name     = name
        self.email    = email
        self.password = password
    }
    
    public static let sagas: [Saga.Type] = []
}
