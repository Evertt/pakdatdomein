extension User: AssertionChecker {
    public enum Assertion {
        case nameIsValid(_ name: String)
        case emailIsValid(_ email: String)
        case passwordIsValid(_ password: String)
    }
    
    public static func check(_ assertion: Assertion) -> Bool {
        switch assertion {
        
        case .nameIsValid(let name):
            return 1...50 ~= name.count

        case .passwordIsValid(let password):
            return password.count > 8
            
        case .emailIsValid(let email):
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            return test.evaluate(with: email)

        }
    }
}
