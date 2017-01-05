extension Domain {
    enum Owner {
        case us, user(userID: ID)
    }
}

extension Domain {
    func isOwned(by owner: Owner?) -> Bool {
        switch (owner, self.owner) {
        case let (.user(potentialOwnerID)?, .user(realOwnerID)?):
            return potentialOwnerID == realOwnerID
        case (.none, .none), (.us?, .us?):
            return true
        default:
            return false
        }
    }
}
