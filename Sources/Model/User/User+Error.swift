extension User {
    enum Error: Swift.Error {
        case invalidName(String)
        case invalidEmail(String)
        case invalidPassword(String)
    }
}

extension User: AssertionChecker {
    /// These are all the things that can go wrong in this app
    
    public enum Assertion {
        case nameIsValid(_ name: String)
        case emailIsValid(_ email: String)
        case passwordIsValid(_ password: String)
    }
    
    public static func check(_ assertion: Assertion) -> Bool {
        switch assertion {
        
        case .nameIsValid(let value) where value.count < 1 || value.count > 50,
             .passwordIsValid(let value) where value.count < 8:
            return false
            
        case .emailIsValid(let email):
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            return test.evaluate(with: email)
            
        default:
            return true
        }
    }
}
