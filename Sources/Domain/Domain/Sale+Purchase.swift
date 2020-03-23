extension Domain {
    struct Sale: Codable {
        let seller   : Owner
        let price    : Money
        var purchase : Purchase?
        
        init(seller: Owner, price: Money) {
            self.seller = seller
            self.price  = price
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
