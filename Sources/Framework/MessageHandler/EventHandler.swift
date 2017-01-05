public protocol FactHandler {
    static var handles: [FactHandlerMethod] { get }
}

public protocol FactHandlerMethod {
    var factType: String { get }
    func handle<T: Fact>(fact: T)
}

struct AFactHandlerMethod<E: Fact>: FactHandlerMethod {
    let handler: (E) -> Void
    let factType: String
    
    init(handler: @escaping (E) -> Void) {
        self.handler = handler
        factType = "\(E.self)"
    }
    
    func handle<T: Fact>(fact: T) {
        guard let fact = fact as? E else {
            fatalError("This should never happen...")
        }
        
        handler(fact)
    }
}

public prefix func ~<E: Fact>(handleMethod: @escaping (E) -> Void) -> FactHandlerMethod {
    return AFactHandlerMethod(handler: handleMethod)
}
