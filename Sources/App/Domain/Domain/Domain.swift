final class Domain: AggregateRoot {
    let id       : ID
    let url      : URL
    var owner    : Owner
    var archived : Bool
    
    var uncommittedEvents = [Event]()
    
    init(
        id: ID,
        url: URL,
        owner: Owner = .outsider,
        archived: Bool = false
    ) {
        self.id       = id
        self.url      = url
        self.owner    = owner
        self.archived = archived
    }
}