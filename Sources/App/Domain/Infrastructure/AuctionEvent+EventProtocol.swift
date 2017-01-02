extension Auction.Event: App.Event {
    enum EventName: String {
        case auctionOpened
        case auctionCanceled
        case auctionCompleted
        case auctionExtended

        case bidAdded
        case bidCanceled
    }

    init(node: Node, in context: Context) throws {
        guard let (name, values) = node.nodeObject?.first else {
            throw NodeError.unableToConvert(node: node, expected: "\([String:Node].self)")
        }
        
        switch name {
        case EventName.auctionOpened.rawValue:
            self = try .auctionOpened(
                auctionID : values.extract("auctionID"),
                domainID  : values.extract("domainID"),
                start     : values.extract("start"),
                end       : values.extract("end")
            )
            
        case EventName.auctionCanceled.rawValue:
            self = .auctionCanceled
            
        case EventName.auctionCompleted.rawValue:
            self = .auctionCompleted
            
        case EventName.auctionExtended.rawValue:
            self = try .auctionExtended(
                newEndDate: values.extract("newEndDate")
            )
            
        case EventName.bidAdded.rawValue:
            self = try .bidAdded(
                bidID  : values.extract("bidID"),
                userID : values.extract("userID"),
                amount : values.extract("amount")
            )
            
        case EventName.bidCanceled.rawValue:
            self = try .bidCanceled(
                bidID: values.extract("bidID")
            )
            
        default:
            fatalError()
        }
    }

    func makeNode(context: Context) throws -> Node {
        switch self {
        case let .auctionOpened(auctionID, domainID, start, end):
            return try [
                EventName.auctionOpened.rawValue: [
                    "auctionID" : auctionID.makeNode(),
                    "domainID"  : domainID.makeNode(),
                    "start"     : start.makeNode(),
                    "end"       : end.makeNode()
                ]
            ]
            
        case .auctionCanceled:
            return [EventName.auctionCanceled.rawValue: .null]
            
        case .auctionCompleted:
            return [EventName.auctionCompleted.rawValue: .null]
            
        case let .auctionExtended(newEndDate):
            return try [
                EventName.auctionExtended.rawValue: [
                    "newEndDate": newEndDate.makeNode()
                ]
            ]
            
        case let .bidAdded(bidID, userID, amount):
            return try [
                EventName.bidAdded.rawValue: [
                    "bidID"  : bidID.makeNode(),
                    "userID" : userID.makeNode(),
                    "amount" : amount.makeNode()
                ]
            ]
            
        case let .bidCanceled(bidID):
            return try [
                EventName.bidCanceled.rawValue: [
                    "bidID": bidID.makeNode()
                ]
            ]
        }
    }
}
