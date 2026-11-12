import Tokens
import Syntax

public final class SemanticFunction {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let parameters: [SemanticParameter]
    
    public let returnType: SemanticType
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _body: [SemanticStatement]?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.location = location
        for parameter in parameters {
            precondition(parameter._container == nil, "A parameter is already declared by a function or initializer")
            parameter._container = _Container(self)
        }
    }
    
    @inlinable
    public var body: [SemanticStatement]? {
        get { _body }
        set {
            _body = newValue
        }
    }
}

extension SemanticFunction: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticFunction, rhs: SemanticFunction) -> Bool { lhs === rhs }
}

extension SemanticFunction: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticFunction: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: [
                "name": name,
                "accessLevel": accessLevel,
                "isExternal": isExternal,
                "parameters": parameters,
                "returnType": returnType,
                "location": location as Any,
                "body": body as Any
            ],
            displayStyle: .class
        )
    }
}
