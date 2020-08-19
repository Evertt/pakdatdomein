extension User {
    public struct Password: Codable {
        let hash: String
        
        init(_ value: String) throws {
            guard let hash = Password.hash(value) else {
                throw Error.invalidPassword(value)
            }
            
            self.hash = hash
        }
        
        static func hash(_ str: String) -> String? {
            return "TODO: use an actual hasher library..."
        }
    }
}
