extension User {
    public struct Name {
        let value: String
        
        init(_ value: String) throws {
            guard case 1...50 = value.count else {
                throw Error.invalidName(value)
            }
            
            self.value = value
        }
    }
}
