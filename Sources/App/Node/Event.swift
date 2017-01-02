protocol Event: RawRepresentable, Equatable, NodeConvertible, JSONConvertible {
    typealias RawValue = Node
}

extension Event {
    var rawValue: Node {
        return try! makeNode()
    }

    init?(rawValue: Node) {
        guard let event = try? Self(node: rawValue) else {
            return nil
        }

        self = event
    }

    static func ==(left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}