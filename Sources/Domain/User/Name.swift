extension User {
    public struct Name: Codable {
        let value: String
        
        init(_ value: String) throws {
            guard case 1...50 = value.count else {
                throw Error.invalidName(value)
            }
            
            self.value = value
        }
    }
}
