// This is just a draft. Don't review this code please.

class EventBus {
    var handlers = HandlerStack()

    func subscribe<T: AnyObject, E: Event>(
        _ handler: @escaping (T) -> (E) -> (), of target: T, to id: ID? = nil, once: Bool = false
    ) {
        handlers.append(SpecificEventHandler(target: target, handler: handler, id: id, once: once))
    }

    func subscribe<T: AnyObject>(
        _ handler: @escaping (T) -> (Event) -> (), of target: T, to type: AggregateRoot.Type? = nil, once: Bool = false
    ) {
        handlers.append(AnyEventHandler(target: target, handler: handler, type: type, once: once))
    }

    func subscribeOnce<T: AnyObject, E: Event>(
        _ handler: @escaping (T) -> (E) -> (), of target: T, to id: ID? = nil
    ) {
        subscribe(handler, of: target, to: id, once: true)
    }

    func subscribeOnce<T: AnyObject>(
        _ handler: @escaping (T) -> (Event) -> (), of target: T, to type: AggregateRoot.Type? = nil
    ) {
        subscribe(handler, of: target, to: type, once: true)
    }

    func fireEvents(of aggregateRoot: AggregateRoot) {
        for event in aggregateRoot.uncommittedEvents {
            handlers[event, from: aggregateRoot] = handlers[event, from: aggregateRoot].filter { handler in
                return handler.fire(event: event, from: type(of: aggregateRoot)) != .stopped
            }
        }
    }
}
