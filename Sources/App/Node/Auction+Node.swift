extension Domain.Owner: NodeConvertible {
    init(node: Node, in context: Context) {
        switch node {
        case let .string(string):
            switch string {
            case "outsider":
                self = .outsider
            case "us":
                self = .us
            default:
                fatalError()
            }
        case let .number(number):
            self = .user(userID: ID(number.int))
        default:
            fatalError()
        }
    }
    
    func makeNode(context: Context) throws -> Node {
        switch self {
        case .outsider:
            return "outsider"
        case .us:
            return "us"
        case .user(let userID):
            return try userID.makeNode()
        }
    }
}

extension Auction.Event: App.Event {
    init(node: Node, in context: Context) throws {
        guard let (name, values) = node.nodeObject?.first else {
            throw NodeError.unableToConvert(node: node, expected: "\([String:Node].self)")
        }
        
        switch name {
        case "auctionOpened":
            self = try .auctionOpened(
                auctionID : values.extract("auctionID"),
                owner     : values.extract("owner"),
                start     : values.extract("start"),
                end       : values.extract("end")
            )
            
        case "auctionCanceled":
            self = .auctionCanceled
            
        case "auctionCompleted":
            self = .auctionCompleted
            
        case "auctionExtended":
            self = try .auctionExtended(
                newEndDate: values.extract("newEndDate")
            )
            
        case "bidAdded":
            self = try .bidAdded(
                bidID  : values.extract("bidID"),
                userID : values.extract("userID"),
                amount : values.extract("amount")
            )
            
        case "bidCanceled":
            self = try .bidCanceled(
                bidID: values.extract("bidID")
            )
            
        default:
            fatalError()
        }
    }

    func makeNode(context: Context) throws -> Node {
        switch self {
        case let .auctionOpened(auctionID, owner, start, end):
            return try ["auctionOpened": [
                "auctionID" : auctionID.makeNode(),
                "owner"     : owner.makeNode(),
                "start"     : start.makeNode(),
                "end"       : end.makeNode()
            ]]
            
        case .auctionCanceled:
            return ["auctionCanceled": .null]
            
        case .auctionCompleted:
            return ["auctionCompleted": .null]
            
        case let .auctionExtended(newEndDate):
            return try ["auctionExtended": [
                "newEndDate": newEndDate.makeNode()
            ]]
            
        case let .bidAdded(bidID, userID, amount):
            return try ["bidAdded": [
                "bidID"  : bidID.makeNode(),
                "userID" : userID.makeNode(),
                "amount" : amount.makeNode()
            ]]
            
        case let .bidCanceled(bidID):
            return try ["bidCanceled": ["bidID": bidID.makeNode()]]
        }
    }
}
