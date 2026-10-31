public struct BitWidth: Hashable, Sendable {

    public let value: Int

    @inlinable
    public init(_ value: Int) {
        precondition(1...8388608 ~= value, "Expected a bit width between 1 and 8388608, but got \(value)")
        self.value = value
    }
}

extension BitWidth: CustomStringConvertible {

    @inlinable
    public var description: String { value.description }
}

extension BitWidth: CustomDebugStringConvertible {

    @inlinable
    public var debugDescription: String { "Syntax.BitWidth(\(value))" }
}

extension BitWidth: ExpressibleByIntegerLiteral {

    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
