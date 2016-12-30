extension User {
    struct Name {
        let value: String
        
        init?(_ value: String) {
            guard case 1...50 = value.characters.count else {
                return nil
            }
            
            self.value = value
        }
    }
}