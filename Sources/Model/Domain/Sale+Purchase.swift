extension Domain {
    struct Sale: Codable {
        let seller   : Owner
        let price    : Money
        var purchase : Purchase? = nil
    }
}

extension Domain.Sale {
    struct Purchase: Codable {
        let userID : ID
        let price  : Money
    }
}
