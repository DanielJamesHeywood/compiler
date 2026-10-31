import Tokens

public struct SyntacticDeclaration: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case constant(
            Identifier,
            isExternal: Bool,
            type: SyntacticType,
            initialValue: SyntacticExpression?
        )
        case function(
            Identifier,
            isExternal: Bool,
            parameters: [SyntacticParameter],
            returnType: SyntacticType,
            body: [SyntacticStatement]?
        )
        case initializer(
            parameters: [SyntacticParameter],
            body: [SyntacticStatement]?
        )
        case structure(
            Identifier,
            members: [SyntacticDeclaration]
        )
        case variable(
            Identifier,
            isExternal: Bool,
            type: SyntacticType,
            initialValue: SyntacticExpression?
        )
    }
    
    public let kind: Kind
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation
    
    @inlinable
    internal init(_kind: Kind, accessLevel: AccessLevel?, at location: SourceLocation) {
        self.kind = _kind
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public static func constant(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool,
        type: SyntacticType,
        initialValue: SyntacticExpression?,
        at location: SourceLocation
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .constant(name, isExternal: isExternal, type: type, initialValue: initialValue),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func function(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool,
        parameters: [SyntacticParameter],
        returnType: SyntacticType,
        body: [SyntacticStatement]?,
        at location: SourceLocation
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .function(name, isExternal: isExternal, parameters: parameters, returnType: returnType, body: body),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func initializer(
        accessLevel: AccessLevel?,
        parameters: [SyntacticParameter],
        body: [SyntacticStatement]?,
        at location: SourceLocation
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .initializer(parameters: parameters, body: body),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func structure(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        members: [SyntacticDeclaration],
        at location: SourceLocation
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .structure(name, members: members),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func variable(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool,
        type: SyntacticType,
        initialValue: SyntacticExpression?,
        at location: SourceLocation
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .variable(name, isExternal: isExternal, type: type, initialValue: initialValue),
            accessLevel: accessLevel,
            at: location
        )
    }
}
