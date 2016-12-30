enum Event {
    case domainFound(domainID: ID)
    case domainOrderedByUser(domainID: ID, userID: ID)
    case orderConvertedToAuction(orderID: ID, auctionID: ID)
    case domainLost(domainID: ID)
    case domainCaptured(domainID: ID)
    case orderCompleted(orderID: ID)
    case bidCancelled(bidID: ID)
    case auctionCompleted(auctionID: ID)
    case userPutDomainOnSale(userID: ID, domainID: ID)
}

enum Command {
    case orderDomain(domainID: ID)
    case cancelOrder(orderID: ID)
    case bidOnOrder(orderID: ID)
    case bidOnAuction(auctionID: ID)
    case cancelAuction(auctionID: ID)
    case cancelBid(bidID: ID)
}