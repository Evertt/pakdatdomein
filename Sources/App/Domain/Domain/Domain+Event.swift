extension Domain {
    enum Event {
        case domainFound(domainID: ID, url: URL)
        case domainGrabbed
        case domainLost
        case domainChangedOwner(newOwner: Owner)
    }
}
