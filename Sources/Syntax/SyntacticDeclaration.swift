import Tokens

public struct SyntacticDeclaration: Sendable {
    
    public enum Kind: Hashable, Sendable {
        case structure(
            Identifier,
            isExternal: Bool,
            members: [SyntacticDeclaration]
        )
        case constant(
            Identifier,
            isExternal: Bool,
            type: SyntacticType,
            initialValue: SyntacticExpression?
        )
        case variable(
            Identifier,
            isExternal: Bool,
            type: SyntacticType,
            initialValue: SyntacticExpression?
        )
        case initializer(
            parameters: [SyntacticParameter],
            body: [SyntacticStatement]?
        )
        case function(
            Identifier,
            isExternal: Bool,
            parameters: [SyntacticParameter],
            returnType: SyntacticType,
            body: [SyntacticStatement]?
        )
    }
    
    public let kind: Kind
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, accessLevel: AccessLevel, at location: SourceLocation?) {
        self.kind = _kind
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public static func structure(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        members: [SyntacticDeclaration],
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .structure(name, isExternal: isExternal, members: members),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func structure(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool = false,
        @ArrayBuilder<SyntacticDeclaration> makeMembers: () -> [SyntacticDeclaration]
    ) -> SyntacticDeclaration {
        .structure(
            name,
            accessLevel: accessLevel,
            isExternal: isExternal,
            members: makeMembers()
        )
    }
    
    @inlinable
    public static func constant(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool = false,
        type: SyntacticType,
        initialValue: SyntacticExpression? = nil,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .constant(name, isExternal: isExternal, type: type, initialValue: initialValue),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func variable(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool = false,
        type: SyntacticType,
        initialValue: SyntacticExpression? = nil,
        at location: SourceLocation? = nil
    ) -> SyntacticDeclaration {
        SyntacticDeclaration(
            _kind: .variable(name, isExternal: isExternal, type: type, initialValue: initialValue),
            accessLevel: accessLevel,
            at: location
        )
    }
    
    @inlinable
    public static func initializer(
        accessLevel: AccessLevel,
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
        accessLevel: AccessLevel,
        parameters: SyntacticParameter...,
        @ArrayBuilder<SyntacticStatement> makeBody: () -> [SyntacticStatement]
    ) -> SyntacticDeclaration {
        .initializer(
            accessLevel: accessLevel,
            parameters: parameters,
            body: makeBody()
        )
    }
    
    @inlinable
    public static func function(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
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
}

extension SyntacticDeclaration: Equatable {
    
    @inlinable
    public static func == (lhs: SyntacticDeclaration, rhs: SyntacticDeclaration) -> Bool {
        lhs.kind == rhs.kind && lhs.accessLevel == rhs.accessLevel
    }
}

extension SyntacticDeclaration: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(accessLevel)
    }
}
