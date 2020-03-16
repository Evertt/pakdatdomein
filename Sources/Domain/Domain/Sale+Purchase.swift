extension Domain {
    struct Sale: Codable {
        let owner    : Owner
        let price    : Money
        var purchase : Purchase?
        
        init(owner: Owner, price: Money) {
            self.owner    = owner
            self.price    = price
        }
    }
}

extension Domain.Sale {
    struct Purchase: Codable {
        let userID : ID
        let price  : Money
        
        init(userID: ID, price: Money) {
            self.userID = userID
            self.price  = price
        }
    }
}
