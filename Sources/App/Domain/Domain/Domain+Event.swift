extension Domain {
    enum Event {
        case domainFound(domainID: ID, url: URL)
        case domainGrabbed
        case domainLost
        case domainChangedOwner(newOwner: Owner)
    }
}

extension Domain {
    static func apply(event: Event, to domain: Domain!) -> Domain {
        switch event {
        
        case let .domainFound(domainID, url):
            return Domain(id: domainID, url: url)
            
        case .domainGrabbed:
            domain.owner = .us
        
        case .domainLost:
            domain.archived = true

        case let .domainChangedOwner(newOwner):
            domain.owner = newOwner

        }
        
        return domain
    }
}
