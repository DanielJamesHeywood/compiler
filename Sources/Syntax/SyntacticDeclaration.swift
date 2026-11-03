import Tokens

public struct SyntacticDeclaration: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case constant(
            Identifier,
            isExternal: Bool,
            type: SyntacticType
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
            type: SyntacticType
        )
    }
    
    public let kind: Kind
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.kind = _kind
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public static func constant(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        isExternal: Bool = false,
        type: SyntacticType,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .constant(name, isExternal: isExternal, type: type),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func function(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        isExternal: Bool = false,
        parameters: [SyntacticParameter],
        returnType: SyntacticType,
        body: [SyntacticStatement]? = nil,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .function(name, isExternal: isExternal, parameters: parameters, returnType: returnType, body: body),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func function(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        isExternal: Bool = false,
        parameters: [SyntacticParameter],
        returnType: SyntacticType,
        @ArrayBuilder<SyntacticStatement> makeBody: () -> [SyntacticStatement]
    ) -> SyntacticDeclaration {
        .function(
            name,
            accessLevel: accessLevel,
            isExternal: isExternal,
            parameters: parameters,
            returnType: returnType,
            body: makeBody()
        )
    }
    
    @inlinable
    public static func initializer(
        accessLevel: AccessLevel? = nil,
        parameters: [SyntacticParameter],
        body: [SyntacticStatement]? = nil,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .initializer(parameters: parameters, body: body),
            accessLevel: accessLevel,
            at: location
        )
    }

    @inlinable
    public static func initializer(
        accessLevel: AccessLevel? = nil,
        parameters: [SyntacticParameter],
        @ArrayBuilder<SyntacticStatement> makeBody: () -> [SyntacticStatement]
    ) -> SyntacticDeclaration {
        .initializer(
            accessLevel: accessLevel,
            parameters: parameters,
            body: makeBody()
        )
    }
    
    @inlinable
    public static func structure(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        members: [SyntacticDeclaration],
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .structure(name, members: members),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func structure(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        @ArrayBuilder<SyntacticDeclaration> makeMembers: () -> [SyntacticDeclaration]
    ) -> SyntacticDeclaration {
        .structure(
            name,
            accessLevel: accessLevel,
            members: makeMembers()
        )
    }
    
    @inlinable
    public static func variable(
        _ name: Identifier,
        accessLevel: AccessLevel? = nil,
        isExternal: Bool = false,
        type: SyntacticType,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .variable(name, isExternal: isExternal, type: type),
            accessLevel: accessLevel,
            at: location
        )
    }
}
