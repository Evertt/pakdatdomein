class Sale: Aggregate {
    let id       : ID
    let domainID : ID
    let price    : Money
    var status   : Status

    init(
        id       : ID,
        domainID : ID,
        price    : Money = Default.priceOfDomain,
        status   : Status = .active
    ) {
        self.id       = id
        self.domainID = domainID
        self.price    = price
        self.status   = status
    }
}