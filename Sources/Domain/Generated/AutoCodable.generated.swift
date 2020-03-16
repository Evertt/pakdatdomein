// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Domain.Business {

    enum CodingKeys: String, CodingKey {
        case auction
        case sale
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.auction), try container.decodeNil(forKey: .auction) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .auction)
            let associatedValue0 = try associatedValues.decode(Domain.Auction.self)
            self = .auction(associatedValue0)
            return
        }
        if container.allKeys.contains(.sale), try container.decodeNil(forKey: .sale) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .sale)
            let associatedValue0 = try associatedValues.decode(Domain.Sale.self)
            self = .sale(associatedValue0)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .auction(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .auction)
            try associatedValues.encode(associatedValue0)
        case let .sale(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .sale)
            try associatedValues.encode(associatedValue0)
        }
    }

}
