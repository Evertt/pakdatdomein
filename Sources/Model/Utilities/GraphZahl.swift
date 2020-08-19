extension Domain: GraphQLObject {}

extension URL: GraphQLScalar {
    public init(scalar: ScalarValue) throws {
        // attempt to read a string and read a url from it
        guard let url = URL(string: try scalar.string()) else {
            fatalError()
        }
        self = url
    }

    public func encodeScalar() throws -> ScalarValue {
        // delegate encoding to absolute string
        return try absoluteString.encodeScalar()
    }
}


extension ID: GraphQLScalar {
    public init(scalar: ScalarValue) throws {
        try self.init(scalar.int())
    }

    public func encodeScalar() throws -> ScalarValue {
        return try value.encodeScalar()
    }
}

extension Domain.Owner: GraphQLScalar {
    public init(scalar: ScalarValue) throws {
        if let userID = try? ID(scalar: scalar) {
            self = .user(userID: userID)
        } else {
            self = .us
        }
    }

    public func encodeScalar() throws -> ScalarValue {
        var userID: ID? = nil
        
        if case let .user(id) = self {
            userID = id
        }
        
        return try userID?.encodeScalar() ?? "us".encodeScalar()
    }
}
