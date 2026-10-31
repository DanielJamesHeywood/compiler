public struct Identifier: Hashable, Sendable {
    
    public let text: String
    
    @inlinable
    internal init(_text: String) {
        precondition(
            _text.wholeMatch(of: /[a-zA-Z_][a-zA-Z_0-9]*/) != nil,
            "Expected an identifier, but got \(_text.debugDescription)"
        )
        self.text = _text
    }

    @inlinable
    public init(_ text: Substring) {
        self.init(_text: String(text))
    }
}

extension Identifier: CustomStringConvertible {
    
    @inlinable
    public var description: String { text }
}

extension Identifier: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String { "Tokens.Identifier(\(text.debugDescription))" }
}

extension Identifier: ExpressibleByStringLiteral {
    
    @inlinable
    public init(stringLiteral text: String) {
        self.init(_text: text)
    }
}
