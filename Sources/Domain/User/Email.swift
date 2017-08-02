extension User {
    public struct Email {
        let value: String
        
        init(_ value: String) throws {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            
            guard test.evaluate(with: value) else {
                throw Error.invalidEmail(value)
            }
            
            self.value = value
        }
    }
}
