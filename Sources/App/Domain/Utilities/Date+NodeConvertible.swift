import Foundation

extension Date: NodeConvertible {
    static fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.ssssss"
        return dateFormatter
    }()
    
    public func makeNode(context: Context) throws -> Node {
        let string = Date.dateFormatter.string(from:self)
        
        return Node(string)
    }
    
    public init(node: Node, in context: Context) throws {
        guard let string = node.string else {
            throw NodeError.unableToConvert(node: node, expected: "\(String.self)")
        }

        guard let date = Date.dateFormatter.date(from: string) else {
            throw NodeError.unableToConvert(
                node: node, expected: "A string in the format of \"\(Date.dateFormatter)\""
            )
        }

        self = date
    }
}