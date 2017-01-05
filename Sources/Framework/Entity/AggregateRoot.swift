public protocol Entity: class {
    var id: ID { get }
}

public protocol AggregateRoot: Entity {
    var version: Int { get set }
    var uncommittedFacts: [Fact] { get set }
    
    static var handles: [String:TaskHandler] { get }
    static var applies: [String:FactApplier] { get }
}

extension AggregateRoot {
    static func load(from history: [Fact]?) -> Self? {
        return history?.reduce(nil) { $0.apply($1) }
    }

    static func load(from history: [Event]?) -> Self? {
        return history?.reduce(nil) { $0.apply($1.fact) }
    }
    
    @discardableResult
    func handle(_ task: Task) throws -> Self {
        guard let taskHandler = Self.handles[task.type] else {
            throw Error.noTaskHandlerFound(task: type(of: task))
        }
        
        return try taskHandler.handle(task: task, for: self)
    }
    
    static func handle(_ task: Task) throws -> Self {
        guard let taskHandler = handles[task.type] else {
            throw Error.noTaskHandlerFound(task: type(of: task))
        }
        
        return try taskHandler.handle(task: task, for: nil)
    }
    
    public func apply(_ fact: Fact) {
        apply(fact, isNew: true)
    }
    
    public static func apply(_ fact: Fact) -> Self {
        return apply(fact, isNew: true)
    }
    
    func apply(_ fact: Fact, isNew: Bool) {
        guard let factApplier = Self.applies[fact.type] else {
            print("No fact applier found for \(type(of: fact))")
            return
        }
        
        if isNew { uncommittedFacts.append(fact) }
        factApplier.apply(fact: fact, on: self)
    }
    
    static func apply(_ fact: Fact, isNew: Bool) -> Self {
        guard let factApplier = applies[fact.type] else {
            fatalError("No fact applier found for \(type(of: fact))")
        }
        
        let entity: Self = factApplier.apply(fact: fact, on: nil)
        if isNew { entity.uncommittedFacts.append(fact) }
        return entity
    }
}

enum Error: Swift.Error {
    case noTaskHandlerFound(task: Task.Type)
    case taskNotRightType(expected: Task.Type, got: Task.Type)
    case aggregateRootNotRightType(expected: AggregateRoot.Type, got: AggregateRoot.Type)
}
