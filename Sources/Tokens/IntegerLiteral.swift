public struct IntegerLiteral: Hashable, Sendable {
    
    public let text: String
    
    @inlinable
    internal init(_text: String) {
        precondition(
            _text.wholeMatch(of: /-?(?:0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9a-fA-F][0-9a-fA-F_]*|[0-9][0-9_]*)/) != nil,
            "Expected an integer literal, but got \(_text.debugDescription)"
        )
        self.text = _text
    }

    @inlinable
    public init(_ text: Substring) {
        self.init(_text: String(text))
    }
}

extension IntegerLiteral: CustomStringConvertible {
    
    @inlinable
    public var description: String { text }
}

extension IntegerLiteral: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String { "Tokens.IntegerLiteral(\(text.debugDescription))" }
}

extension IntegerLiteral: ExpressibleByStringLiteral {
    
    @inlinable
    public init(stringLiteral text: String) {
        self.init(_text: text)
    }
}
