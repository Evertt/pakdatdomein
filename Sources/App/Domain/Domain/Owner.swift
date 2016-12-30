extension Domain {
    enum Owner {
        case outsider, us, user(userID: ID)
    }
}

extension Domain {
    func isOwned(by owner: Owner) -> Bool {
        switch (owner, self.owner) {
        case let (.user(potentialOwnerID), .user(realOwnerID)):
            return potentialOwnerID == realOwnerID
        case (.outsider, .outsider), (.us, .us):
            return true
        default:
            return false
        }
    }
}
