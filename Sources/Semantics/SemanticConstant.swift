import Tokens
import Syntax

public final class SemanticConstant {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let initialValue: SemanticExpression?
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        initialValue: SemanticExpression?,
        at location: SourceLocation?
    ) {
        self.name = name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.type = type
        self.initialValue = initialValue
        self.location = location
    }
    
    @inlinable
    public var containingModule: SemanticModule? {
        guard case let .module(weakModule) = _container else {
            return nil
        }
        guard let module = weakModule.object else {
            preconditionFailure("The module has been deallocated")
        }
        return module
    }
}

extension SemanticConstant: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticConstant, rhs: SemanticConstant) -> Bool { lhs === rhs }
}

extension SemanticConstant: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticConstant: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: [
                "name": name,
                "accessLevel": accessLevel,
                "isExternal": isExternal,
                "type": type,
                "initialValue": initialValue as Any,
                "location": location as Any
            ],
            displayStyle: .class
        )
    }
}
