import SystemPackage

public struct SourceLocation: Hashable, Sendable {
    
    public let path: FilePath
    
    public let line: Int
    
    public let column: Int
    
    @inlinable
    public init(path: FilePath, line: Int, column: Int) {
        precondition(
            path.extension == "source",
            "Expected a path with extension \"source\", but got \(path.debugDescription)"
        )
        precondition(
            line >= 1,
            "Expected a line number of at least 1, but got \(line)"
        )
        precondition(
            column >= 1,
            "Expected a column number of at least 1, but got \(column)"
        )
        self.path = path
        self.line = line
        self.column = column
    }
}
