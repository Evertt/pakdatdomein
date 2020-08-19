public struct FailedAssertions<Assertion>: Error {
    let assertions: [Assertion]
    
    public init(_ assertions: [Assertion]) {
        self.assertions = assertions
    }
}

extension FailedAssertions: Collection {
    public var startIndex: Int { assertions.startIndex }
    public var endIndex: Int { assertions.endIndex }

    public subscript(index: Int) -> Assertion {
        get { assertions[index] }
    }

    public func index(after i: Int) -> Int {
        return assertions.index(after: i)
    }
}

extension FailedAssertions: ExpressibleByArrayLiteral {
    public init(arrayLiteral assertions: Assertion...) {
        self.init(assertions)
    }
}

public protocol AssertionChecker {
    associatedtype Assertion
    
    typealias FailedAssertions = Framework.FailedAssertions<Assertion>
    typealias AssertionResult = Result<Void, FailedAssertions>
    
    static func check(_ assertion: Assertion) -> Bool
    func check(_ assertion: Assertion) -> Bool
}

public extension AssertionChecker {
    static func check(_ assertion: Assertion) -> Bool {
        return false
    }
    
    static func check(_ firstAssertion: Assertion, _ moreAssertions: Assertion...) -> Bool {
        return check([firstAssertion] + moreAssertions)
    }
    
    static func check(_ assertions: [Assertion]) -> Bool {
        return !assertions.map(check).contains(false)
    }
    
    static func check(_ assertions: [Assertion]) -> AssertionResult {
        let failedAssertions = assertions.exclude(check)

        return failedAssertions.isEmpty
             ? .success(())
             : .failure(.init(failedAssertions))
    }
    
    static func check(_ assertions: Assertion...) -> AssertionResult {
        return check(assertions)
    }

    static func ensure(_ assertions: Assertion...) throws {
        try check(assertions).get()
    }
}

public extension AssertionChecker {
    func check(_ assertion: Assertion) -> Bool {
        return Self.check(assertion)
    }
    
    func check(_ firstAssertion: Assertion, _ moreAssertions: Assertion...) -> Bool {
        return check([firstAssertion] + moreAssertions)
    }
    
    func check(_ assertions: [Assertion]) -> Bool {
        return !assertions.map(check).contains(false)
    }
    
    func check(_ assertions: [Assertion]) -> AssertionResult {
        let failedAssertions = assertions.exclude(check)

        return failedAssertions.isEmpty
             ? .success(())
             : .failure(.init(failedAssertions))
    }
    
    func check(_ assertions: Assertion...) -> AssertionResult {
        return check(assertions)
    }

    func ensure(_ assertions: Assertion...) throws {
        try check(assertions).get()
    }
}

extension Array {
    func exclude(_ isExcluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { element in
            return try !isExcluded(element)
        }
    }
}
