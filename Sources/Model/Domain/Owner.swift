extension Domain {
    public enum Owner: Equatable {
        case us, user(userID: ID)
        
        public static func ==(userID: ID, owner: Owner) -> Bool {
            return owner == .user(userID: userID)
        }
    }
}

extension Domain.Owner: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if (try? container.decode(String.self)) == "us" {
            self = .us
        } else {
            let userID = try container.decode(Int.self)
            self = .user(userID: ID(userID))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .us:
            return try container.encode("us")
        case let .user(userID):
            return try container.encode(userID)
        }
    }
}
