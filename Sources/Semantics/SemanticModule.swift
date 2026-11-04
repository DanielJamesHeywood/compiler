public final class SemanticModule {}

extension SemanticModule: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticModule, rhs: SemanticModule) -> Bool { lhs === rhs }
}

extension SemanticModule: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
