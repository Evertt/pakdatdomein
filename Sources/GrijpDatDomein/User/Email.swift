extension User {
    struct Email {
        let value: String
        
        init?(_ value: String) {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            guard test.evaluate(with: value) else { return nil }
            
            self.value = value
        }
    }
}