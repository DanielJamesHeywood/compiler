import Tokens
import Syntax

public final class SemanticInitializer {
    
    public let accessLevel: AccessLevel
    
    public let parameters: [SemanticParameter]
    
    public let location: SourceLocation?
    
    public var body: [SemanticStatement]?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(accessLevel: AccessLevel, parameters: [SemanticParameter], at location: SourceLocation?) {
        self.accessLevel = accessLevel
        self.parameters = parameters
        self.location = location
        for parameter in parameters {
            precondition(parameter._container == nil, "A parameter is already declared by a function or initializer")
            parameter._container = _Container(self)
        }
    }
    
    @inlinable
    public var containingStructure: SemanticStructure {
        guard case let .structure(weakStructure) = _container else {
            preconditionFailure("The initializer is not a member of a structure")
        }
        guard let structure = weakStructure.object else {
            preconditionFailure("The structure has been deallocated")
        }
        return structure
    }
}

extension SemanticInitializer: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticInitializer, rhs: SemanticInitializer) -> Bool { lhs === rhs }
}

extension SemanticInitializer: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticInitializer: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: [
                "accessLevel": accessLevel,
                "parameters": parameters,
                "location": location as Any,
                "body": body as Any
            ],
            displayStyle: .class
        )
    }
}
