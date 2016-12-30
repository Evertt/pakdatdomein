protocol Entity: Hashable {
    var id: ID { get }
}

extension Entity {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(left: Self, right: Self) -> Bool {
        return left.id == right.id
    }
}