extension Double {
    var euro: Money {
        return Money(amount: Decimal(self), currency: .eur)
    }
    
    var dollar: Money {
        return Money(amount: Decimal(self), currency: .usd)
    }
}

class FoundDomainSaga: Saga {
    let bus: Bus

    public required init(bus: Bus) {
        self.bus = bus
        
        bus.subscribe(domainFound)
    }
    
    func domainFound(event: Domain.DomainFound) throws {
        try bus.send(Domain.PutOnSale(id: event.id, price: 99.euro))
        
        bus.subscribeOnce(purchaseRequested, to: event.id)
    }

    func purchaseRequested(event: Domain.PurchaseRequested) {
        bus.subscribeOnce(domainLost,       to: event.id)
        bus.subscribeOnce(domainGrabbed,    to: event.id)
        bus.subscribeOnce(purchaseCanceled, to: event.id)
    }

    func purchaseCanceled(event: Domain.PurchaseCanceled) {
        bus.removeSubscription(domainLost,    from: event.id)
        bus.removeSubscription(domainGrabbed, from: event.id)
        bus.subscribeOnce(purchaseRequested,  to:   event.id)
    }

    func domainGrabbed(event: Domain.DomainGrabbed) throws {
        try bus.send(Domain.CompletePurchase(id: event.id))
    }

    func domainLost(event: Domain.DomainLost) throws {
        try bus.send(Domain.CancelPurchase(id: event.id))
    }
}

extension Domain {
    public static let sagas: [Saga.Type] = [
        FoundDomainSaga.self,
    ]
}
