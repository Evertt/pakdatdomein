class DomainSaga {
    var domainsFound = Set<ID>()
    let commandBus: CommandBus

    public init(commandBus: CommandBus) {
        self.commandBus = commandBus
    }

    func domainFound(event: Domain.DomainFound) {
        let id      = event.id
        let price   = Money(amount: 99, currency: .eur)
        let command = Domain.PutOnSale(id: id, price: price)

        domainsFound.insert(id)
        try! commandBus.send(command)
    }

    func domainGrabbed(event: Domain.DomainGrabbed) {
        if domainsFound.contains(event.id) {
            
        }
    }

    func domainLost(event: Domain.DomainLost) {

    }
}
