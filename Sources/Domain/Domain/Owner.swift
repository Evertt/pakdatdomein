extension Domain {
    public enum Owner: Equatable {
        case us, user(userID: ID)
        
        public static func ==(userID: ID, owner: Owner) -> Bool {
            return owner == .user(userID: userID)
        }
    }
}
