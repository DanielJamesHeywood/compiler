public struct SourceLocation: Hashable, Sendable {
    
    public let line: Int
    
    public let column: Int
    
    @inlinable
    public init(line: Int, column: Int) {
        precondition(line >= 1, "Expected a line number of at least 1, but got \(line)")
        precondition(column >= 1, "Expected a column number of at least 1, but got \(column)")
        self.line = line
        self.column = column
    }
}

extension SourceLocation: Comparable {
    
    @inlinable
    public static func < (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        (lhs.line, lhs.column) < (rhs.line, rhs.column)
    }
}
