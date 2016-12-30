enum Store {
    static var bids     = [ID:Bid]()
    static var users    = [ID:User]()
    static var sales    = [ID:Sale]()
    static var domains  = [ID:Domain]()
    static var auctions = [ID:Auction]()
    static var purchase = [ID:Purchase]()
}