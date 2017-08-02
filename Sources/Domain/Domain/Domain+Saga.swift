/*

// This is me trying to understand Sagas.
// This is basically me just trying stuff out so don't review this code seriously.

class DomainSaga {
    let commandBus: CommandBus
    var domainsFound = [ID:State]()

    public init(commandBus: CommandBus) {
        self.commandBus = commandBus
    }

    func domainFound(event: Domain.DomainFound) {
        let id      = event.id
        let price   = Money(amount: 99, currency: .eur)
        let command = Domain.PutOnSale(id: id, price: price)

        domainsFound[id] = .found
        try! commandBus.send(command)
    }

    func purchaseRequested(event: Domain.PurchaseRequested) {
        domainsFound[event.id]?.purchaseWasRequested()
    }

    func purchaseCanceled(event: Domain.PurchaseCanceled) {
        domainsFound[event.id]?.wasFound()
    }

    func domainGrabbed(event: Domain.DomainGrabbed) {
        if domainsFound[event.id] == .purchaseRequested {
            try! commandBus.send(Domain.CompletePurchase(id: event.id))
            domainsFound[event.id] = nil
        }
    }

    func domainLost(event: Domain.DomainLost) {
        if domainsFound[event.id] == .purchaseRequested {
            try! commandBus.send(Domain.CancelPurchase(id: event.id))
            domainsFound[event.id] = nil
        }
    }
}

extension DomainSaga {
    enum State {
        case found, purchaseRequested

        mutating func wasFound() {
            self = .found
        }

        mutating func purchaseWasRequested() {
            self = .purchaseRequested
        }

        func ifPurchaseWasRequested(closure: () -> ()) {
            switch self {
                case .purchaseRequested: closure()
                default: return
            }
        }
    }
}






protocol Bus {
    func send(_ command: Command) throws
    func subscribeOnce<T: AnyObject, E: Event>(_ handler: (T) -> (E) throws -> (), of target: T, to id: ID)
}

extension Double {
    var euro: Money {
        return Money(amount: Decimal(self), currency: .eur)
    }
    
    var usd: Money {
        return Money(amount: Decimal(self), currency: .usd)
    }
}

class FoundDomainSaga {
    let bus: Bus

    public init(bus: Bus) {
        self.bus = bus
    }

    static func domainFound(event: Domain.DomainFound, bus: Bus) throws -> FoundDomainSaga {
        try bus.send(Domain.PutOnSale(id: event.id, price: 99.euro))
        
        let saga = FoundDomainSaga(bus: bus)
        bus.subscribeOnce(FoundDomainSaga.purchaseRequested, of: saga, to: event.id)
        return saga
    }

    func purchaseRequested(event: Domain.PurchaseRequested) {
        bus.subscribeOnce(FoundDomainSaga.domainLost,       of: self, to: event.id)
        bus.subscribeOnce(FoundDomainSaga.domainGrabbed,    of: self, to: event.id)
        bus.subscribeOnce(FoundDomainSaga.purchaseCanceled, of: self, to: event.id)
    }

    func purchaseCanceled(event: Domain.PurchaseCanceled) {
        bus.subscribeOnce(FoundDomainSaga.purchaseRequested, of: self, to: event.id)
    }

    func domainGrabbed(event: Domain.DomainGrabbed) throws {
        try bus.send(Domain.CompletePurchase(id: event.id))
    }

    func domainLost(event: Domain.DomainLost) throws {
        try bus.send(Domain.CancelPurchase(id: event.id))
    }
}

*/
