extension Domain {
    struct Sale {
        let owner    : Owner
        let price    : Money
        var purchase : Purchase!
        
        init(owner: Owner, price: Money) {
            self.owner    = owner
            self.price    = price
        }
    }
}
