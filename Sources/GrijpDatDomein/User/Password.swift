extension User {
    struct Password {
        let value: String
        
        init?(_ value: String) {
            guard let value = Password.hash(value) else {
                return nil
            }
            
            self.value = value
        }
        
        static func hash(_ str: String) -> String? {
            return "poep"
        }
    }
}