class FoundDomainSaga: Saga {
    let bus: Bus

    public required init(bus: Bus) {
        self.bus = bus
        
        bus.subscribe(domainFound)
    }
    
    func domainFound(event: Domain.DomainFound) throws {
        try bus.send(Domain.PutOnSale(id: event.id, price: Default.priceOfDomain))
        
        bus.subscribeOnce(domainLost,        to: event.id)
        bus.subscribeOnce(purchaseRequested, to: event.id)
    }

    func purchaseRequested(event: Domain.PurchaseRequested) {
        bus.subscribeOnce(domainGrabbed,    to: event.id)
        bus.subscribeOnce(purchaseCanceled, to: event.id)
    }

    func purchaseCanceled(event: Domain.PurchaseCanceled) {
        bus.removeSubscription(domainGrabbed, from: event.id)
        bus.subscribeOnce(purchaseRequested,  to:   event.id)
    }

    func domainGrabbed(event: Domain.DomainGrabbed) throws {
        bus.removeSubscription(domainLost, from: event.id)
        
        try bus.send(Domain.CompletePurchase(id: event.id))
    }

    func domainLost(event: Domain.DomainLost) throws {
        bus.removeSubscription(purchaseRequested, from: event.id)
        bus.removeSubscription(domainGrabbed,     from: event.id)
        
        try bus.send(Domain.CancelSale(id: event.id))
    }
}

class DomainAuctionSaga: Saga {
    let bus: Bus
    var timers = [ID:Timer]()

    public required init(bus: Bus) {
        self.bus = bus
        
        bus.subscribe(auctionOpened)
    }
    
    func auctionOpened(event: Domain.AuctionOpened) {
        scheduleAuctionToClose(at: event.end, for: event.id)
        
        bus.subscribe(auctionExtended, to: event.id)
        bus.subscribeOnce(auctionCanceled, to: event.id)
        bus.subscribeOnce(auctionCompleted, to: event.id)
    }
    
    func auctionExtended(event: Domain.AuctionExtended) {
        scheduleAuctionToClose(at: event.newEndDate, for: event.id)
    }
    
    func auctionCanceled(event: Domain.AuctionCanceled) {
        cancelAuctionClosure(for: event.id)
        
        bus.removeSubscription(auctionExtended,  from: event.id)
        bus.removeSubscription(auctionCompleted, from: event.id)
    }
    
    func auctionCompleted(event: Domain.AuctionCompleted) {
        cancelAuctionClosure(for: event.id)
        
        bus.removeSubscription(auctionExtended, from: event.id)
        bus.removeSubscription(auctionCanceled, from: event.id)
    }
    
    private func scheduleAuctionToClose(at endDate: Date, for id: ID) {
        cancelAuctionClosure(for: id)
        
        let endTime = Date.now.distance(to: endDate)
        
        timers[id] = Timer.scheduledTimer(withTimeInterval: endTime, repeats: false) {
            [weak self] _ in try? self?.bus.send(Domain.CompleteAuction(id: id))
        }
    }
    
    private func cancelAuctionClosure(for id: ID) {
        timers.removeValue(forKey: id)?.invalidate()
    }
}

extension Domain {
    public static let sagas: [Saga.Type] = [
        FoundDomainSaga.self,
        DomainAuctionSaga.self,
    ]
}
