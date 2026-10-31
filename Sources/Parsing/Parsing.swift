import Syntax
import Tokens

@inlinable
public func syntacticDeclarations(for tokens: [Token]) throws(ParsingError) -> [SyntacticDeclaration] {
    var declarations = [] as [SyntacticDeclaration]
    var unparsedTokens = ArraySlice(tokens)
    while let token = unparsedTokens.first {
        if !token.isAtStartOfLine, !declarations.isEmpty {
            throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveDeclarations)
        }
        declarations.append(try unparsedTokens._parseDeclaration())
    }
    return declarations
}

extension ArraySlice<Token> {
    
    @inlinable
    internal mutating func _parseIdentifier() throws(ParsingError) -> Identifier {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .identifier)
        }
        guard case let .identifier(identifier) = token.kind else {
            throw .unexpectedToken(token, expected: .identifier)
        }
        return identifier
    }
    
    @inlinable
    internal mutating func _parseOpeningParenthesis() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .openingParenthesis)
        }
        guard token.kind == .openingParenthesis else {
            throw .unexpectedToken(token, expected: .openingParenthesis)
        }
    }
    
    @inlinable
    internal mutating func _parseClosingParenthesis() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .closingParenthesis)
        }
        guard token.kind == .closingParenthesis else {
            throw .unexpectedToken(token, expected: .closingParenthesis)
        }
    }
    
    @inlinable
    internal mutating func _parseOpeningBrace() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .openingBrace)
        }
        guard token.kind == .openingBrace else {
            throw .unexpectedToken(token, expected: .openingBrace)
        }
    }
    
    @inlinable
    internal mutating func _parseClosingBrace() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .closingBrace)
        }
        guard token.kind == .closingBrace else {
            throw .unexpectedToken(token, expected: .closingBrace)
        }
    }
    
    @inlinable
    internal mutating func _parseComma() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .comma)
        }
        guard token.kind == .comma else {
            throw .unexpectedToken(token, expected: .comma)
        }
    }
    
    @inlinable
    internal mutating func _parseColon() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .colon)
        }
        guard token.kind == .colon else {
            throw .unexpectedToken(token, expected: .colon)
        }
    }
    
    @inlinable
    internal mutating func _parseEqualsSign() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .equalsSign)
        }
        guard token.kind == .equalsSign else {
            throw .unexpectedToken(token, expected: .equalsSign)
        }
    }
    
    @inlinable
    internal mutating func _parseArrow() throws(ParsingError) {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .arrow)
        }
        guard token.kind == .arrow else {
            throw .unexpectedToken(token, expected: .arrow)
        }
    }
    
    @inlinable
    internal mutating func _parseType() throws(ParsingError) -> SyntacticType {
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: .type)
        }
        guard case let .identifier(identifier) = token.kind else {
            throw .unexpectedToken(token, expected: .type)
        }
        return .identifier(identifier, at: token.location)
    }
    
    @inlinable
    internal mutating func _parseTypeAnnotation() throws(ParsingError) -> SyntacticType {
        try _parseColon()
        return try _parseType()
    }
    
    @inlinable
    internal mutating func _parseExpression() throws(ParsingError) -> SyntacticExpression {
        guard let firstToken = popFirst() else {
            throw .unexpectedEndOfFile(expected: .expression)
        }
        var expression: SyntacticExpression = switch firstToken.kind {
        case let .identifier(identifier):
            .identifier(identifier, at: firstToken.location)
        case .selfKeyword:
            .self(at: firstToken.location)
        case let .integerLiteral(literal):
            .integerLiteral(literal, at: firstToken.location)
        default:
            throw .unexpectedToken(firstToken, expected: .expression)
        }
        while let token = first {
            if token.kind == .openingParenthesis, !token.isAtStartOfLine {
                let arguments = try _parseArguments()
                expression = .call(to: expression, passing: arguments, at: firstToken.location)
            } else if token.kind == .period {
                removeFirst()
                let name = try _parseIdentifier()
                expression = .member(name, of: expression, at: firstToken.location)
            } else {
                break
            }
        }
        return expression
    }
    
    @inlinable
    internal mutating func _parseArguments() throws(ParsingError) -> [SyntacticArgument] {
        var arguments = [] as [SyntacticArgument]
        try _parseOpeningParenthesis()
        while let token = first, token.kind != .closingParenthesis {
            arguments.append(try _parseArgument())
            if first?.kind != .closingParenthesis {
                try _parseComma()
            }
        }
        try _parseClosingParenthesis()
        return arguments
    }
    
    @inlinable
    internal mutating func _parseArgument() throws(ParsingError) -> SyntacticArgument {
        guard let firstToken = first else {
            throw .unexpectedEndOfFile(expected: .argument)
        }
        var label = nil as Identifier?
        if dropFirst().first?.kind == .colon {
            label = try _parseIdentifier()
            removeFirst()
        }
        let value = try _parseExpression()
        return SyntacticArgument(value, label: label, at: firstToken.location)
    }
    
    @inlinable
    internal mutating func _parseStatement() throws(ParsingError) -> SyntacticStatement {
        guard let firstToken = first else {
            throw .unexpectedEndOfFile(expected: .statement)
        }
        switch firstToken.kind {
        case .returnKeyword:
            removeFirst()
            guard let token = first, !token.isAtStartOfLine, token.kind != .closingBrace else {
                return .return(at: firstToken.location)
            }
            let value = try _parseExpression()
            return .return(of: value, at: firstToken.location)
        case .identifier, .selfKeyword, .integerLiteral:
            let destination = try _parseExpression()
            try _parseEqualsSign()
            let source = try _parseExpression()
            return .assignment(of: source, to: destination, at: firstToken.location)
        default:
            throw .unexpectedToken(firstToken, expected: .statement)
        }
    }
    
    @inlinable
    internal mutating func _parseDeclaration() throws(ParsingError) -> SyntacticDeclaration {
        guard let firstToken = first else {
            throw .unexpectedEndOfFile(expected: .declaration)
        }
        let accessLevel = _parseAccessLevelIfPresent()
        let isExternal = _parseExternalKeywordIfPresent()
        let expectation: ParsingError.Expectation = isExternal ? .externalDeclaration : .declaration
        guard let token = popFirst() else {
            throw .unexpectedEndOfFile(expected: expectation)
        }
        switch token.kind {
        case .constantKeyword:
            let name = try _parseIdentifier()
            let type = try _parseTypeAnnotation()
            let initialValue = try _parseInitialValueIfPresent()
            return .constant(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                initialValue: initialValue,
                at: firstToken.location
            )
        case .functionKeyword:
            let name = try _parseIdentifier()
            let parameters = try _parseParameters()
            try _parseArrow()
            let returnType = try _parseType()
            let body = try _parseBodyIfPresent()
            return .function(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                parameters: parameters,
                returnType: returnType,
                body: body,
                at: firstToken.location
            )
        case .initializerKeyword where !isExternal:
            let parameters = try _parseParameters()
            let body = try _parseBodyIfPresent()
            return .initializer(
                accessLevel: accessLevel,
                parameters: parameters,
                body: body,
                at: firstToken.location
            )
        case .structureKeyword where !isExternal:
            let name = try _parseIdentifier()
            let members = try _parseMembers()
            return .structure(
                name,
                accessLevel: accessLevel,
                members: members,
                at: firstToken.location
            )
        case .variableKeyword:
            let name = try _parseIdentifier()
            let type = try _parseTypeAnnotation()
            let initialValue = try _parseInitialValueIfPresent()
            return .variable(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                initialValue: initialValue,
                at: firstToken.location
            )
        default:
            throw .unexpectedToken(token, expected: expectation)
        }
    }
    
    @inlinable
    internal mutating func _parseAccessLevelIfPresent() -> AccessLevel? {
        switch first?.kind {
        case .publicKeyword:
            removeFirst()
            return .public
        case .privateKeyword:
            removeFirst()
            return .private
        default:
            return nil
        }
    }
    
    @inlinable
    internal mutating func _parseExternalKeywordIfPresent() -> Bool {
        guard first?.kind == .externalKeyword else {
            return false
        }
        removeFirst()
        return true
    }
    
    @inlinable
    internal mutating func _parseInitialValueIfPresent() throws(ParsingError) -> SyntacticExpression? {
        if first?.kind == .equalsSign {
            try _parseInitialValue()
        } else {
            nil
        }
    }
    
    @inlinable
    internal mutating func _parseInitialValue() throws(ParsingError) -> SyntacticExpression {
        try _parseEqualsSign()
        return try _parseExpression()
    }
    
    @inlinable
    internal mutating func _parseParameters() throws(ParsingError) -> [SyntacticParameter] {
        var parameters = [] as [SyntacticParameter]
        try _parseOpeningParenthesis()
        while let token = first, token.kind != .closingParenthesis {
            parameters.append(try _parseParameter())
            if first?.kind != .closingParenthesis {
                try _parseComma()
            }
        }
        try _parseClosingParenthesis()
        return parameters
    }
    
    @inlinable
    internal mutating func _parseParameter() throws(ParsingError) -> SyntacticParameter {
        guard let firstToken = first else {
            throw .unexpectedEndOfFile(expected: .parameter)
        }
        var label = nil as Identifier?
        if case .identifier = dropFirst().first?.kind {
            label = try _parseIdentifier()
        }
        let name = try _parseIdentifier()
        let type = try _parseTypeAnnotation()
        return SyntacticParameter(name, label: label, type: type, at: firstToken.location)
    }
    
    @inlinable
    internal mutating func _parseBodyIfPresent() throws(ParsingError) -> [SyntacticStatement]? {
        if first?.kind == .openingBrace {
            try _parseBody()
        } else {
            nil
        }
    }
    
    @inlinable
    internal mutating func _parseBody() throws(ParsingError) -> [SyntacticStatement] {
        var statements = [] as [SyntacticStatement]
        try _parseOpeningBrace()
        while let token = first, token.kind != .closingBrace {
            if !token.isAtStartOfLine, !statements.isEmpty {
                throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveStatements)
            }
            statements.append(try _parseStatement())
        }
        try _parseClosingBrace()
        return statements
    }
    
    @inlinable
    internal mutating func _parseMembers() throws(ParsingError) -> [SyntacticDeclaration] {
        var members = [] as [SyntacticDeclaration]
        try _parseOpeningBrace()
        while let token = first, token.kind != .closingBrace {
            if !token.isAtStartOfLine, !members.isEmpty {
                throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveDeclarations)
            }
            members.append(try _parseDeclaration())
        }
        try _parseClosingBrace()
        return members
    }
}
