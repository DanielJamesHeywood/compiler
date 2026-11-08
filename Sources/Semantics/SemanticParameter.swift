import Tokens

public final class SemanticParameter {
    
    public let name: Identifier
    
    public let label: Identifier?
    
    public let type: SemanticType
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(_ name: Identifier, label: Identifier?, type: SemanticType, at location: SourceLocation?) {
        self.name = name
        self.label = label
        self.type = type
        self.location = location
    }
}

extension SemanticParameter: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticParameter, rhs: SemanticParameter) -> Bool { lhs === rhs }
}

extension SemanticParameter: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticParameter: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: ["name": name, "label": label as Any, "type": type, "location": location as Any],
            displayStyle: .class
        )
    }
}
