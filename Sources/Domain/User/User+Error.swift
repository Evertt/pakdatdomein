extension User {
    enum Error: Swift.Error {
        case invalidName(String)
        case invalidEmail(String)
        case invalidPassword(String)
    }
}
