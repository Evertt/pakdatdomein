// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Domain {
    enum CodingKeys: String, CodingKey {
        case id, url, owner, business
    }
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id, name, email, password, active
    }
}
