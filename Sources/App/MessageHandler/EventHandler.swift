public protocol EventHandler {
    static var handles: [EventHandlerMethod] { get }
}

public protocol EventHandlerMethod {
    var eventType: String { get }
    func handle<T: Event>(event: T)
}

struct AnEventHandlerMethod<E: Event>: EventHandlerMethod {
    let handler: (E) -> Void
    let eventType: String
    
    init(handler: @escaping (E) -> Void) {
        self.handler = handler
        eventType = "\(E.self)"
    }
    
    func handle<T: Event>(event: T) {
        guard let event = event as? E else {
            fatalError("This should never happen...")
        }
        
        handler(event)
    }
}

public prefix func ~<E: Event>(handleMethod: @escaping (E) -> Void) -> EventHandlerMethod {
    return AnEventHandlerMethod(handler: handleMethod)
}
