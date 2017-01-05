extension Domain.Sale {
    struct Purchase {
        let userID   : ID
        let price    : Money
        
        init(userID: ID, price: Money) {
            self.userID   = userID
            self.price    = price
        }
    }
}
