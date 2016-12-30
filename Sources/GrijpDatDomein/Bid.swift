struct Bid {
    let user  : User
    let money : Money
    let date  : Date
    
    init(user: User, money: Money, date: Date = Date()) {
        self.user  = user
        self.money = money
        self.date  = date
    }
}
