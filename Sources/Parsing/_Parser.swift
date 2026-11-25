import Tokens
import Syntax

@usableFromInline
internal final class _Parser {
    
    @usableFromInline
    internal var _unparsedTokens: ArraySlice<Token>
    
    @usableFromInline
    internal let _endOfFileLocation: SourceLocation
    
    @inlinable
    internal init(for tokenizedSourceFile: TokenizedSourceFile) {
        self._unparsedTokens = ArraySlice(tokenizedSourceFile.tokens)
        self._endOfFileLocation = tokenizedSourceFile.endLocation
    }
    
    @inlinable
    internal func parseModule() throws(ParsingError) -> SyntacticModule {
        var declarations = [] as [SyntacticDeclaration]
        while let token = _unparsedTokens.first {
            if !token.isAtStartOfLine, !declarations.isEmpty {
                throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveDeclarations)
            }
            declarations.append(try _parseDeclaration())
        }
        return SyntacticModule(declarations: declarations)
    }
    
    @inlinable
    internal func _parseIdentifier() throws(ParsingError) -> Identifier {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .identifier)
        }
        guard case let .identifier(identifier) = token.kind else {
            throw .unexpectedToken(token, expected: .identifier)
        }
        return identifier
    }
    
    @inlinable
    internal func _parseOpeningParenthesis() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .openingParenthesis)
        }
        guard token.kind == .openingParenthesis else {
            throw .unexpectedToken(token, expected: .openingParenthesis)
        }
    }
    
    @inlinable
    internal func _parseClosingParenthesis() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .closingParenthesis)
        }
        guard token.kind == .closingParenthesis else {
            throw .unexpectedToken(token, expected: .closingParenthesis)
        }
    }
    
    @inlinable
    internal func _parseOpeningBrace() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .openingBrace)
        }
        guard token.kind == .openingBrace else {
            throw .unexpectedToken(token, expected: .openingBrace)
        }
    }
    
    @inlinable
    internal func _parseClosingBrace() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .closingBrace)
        }
        guard token.kind == .closingBrace else {
            throw .unexpectedToken(token, expected: .closingBrace)
        }
    }
    
    @inlinable
    internal func _parseComma() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .comma)
        }
        guard token.kind == .comma else {
            throw .unexpectedToken(token, expected: .comma)
        }
    }
    
    @inlinable
    internal func _parseColon() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .colon)
        }
        guard token.kind == .colon else {
            throw .unexpectedToken(token, expected: .colon)
        }
    }
    
    @inlinable
    internal func _parseEqualsSign() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .equalsSign)
        }
        guard token.kind == .equalsSign else {
            throw .unexpectedToken(token, expected: .equalsSign)
        }
    }
    
    @inlinable
    internal func _parseArrow() throws(ParsingError) {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .arrow)
        }
        guard token.kind == .arrow else {
            throw .unexpectedToken(token, expected: .arrow)
        }
    }
    
    @inlinable
    internal func _parseType() throws(ParsingError) -> SyntacticType {
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .type)
        }
        guard case let .identifier(identifier) = token.kind else {
            throw .unexpectedToken(token, expected: .type)
        }
        return .identifier(identifier, at: token.location)
    }
    
    @inlinable
    internal func _parseExpression() throws(ParsingError) -> SyntacticExpression {
        guard let firstToken = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .expression)
        }
        var expression = switch firstToken.kind {
        case let .identifier(identifier):
            .identifier(identifier, at: firstToken.location)
        case .selfKeyword:
            .self(at: firstToken.location)
        case let .integerLiteral(literal):
            .integerLiteral(literal, at: firstToken.location)
        default:
            throw .unexpectedToken(firstToken, expected: .expression)
        } as SyntacticExpression
        while _unparsedTokens.first?.kind == .period {
            _unparsedTokens.removeFirst()
            let name = try _parseIdentifier()
            expression = .member(name, of: expression, at: firstToken.location)
        }
        return expression
    }
    
    @inlinable
    internal func _parseStatement() throws(ParsingError) -> SyntacticStatement {
        guard let firstToken = _unparsedTokens.first else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .statement)
        }
        switch firstToken.kind {
        case .returnKeyword:
            _unparsedTokens.removeFirst()
            let value = if let token = _unparsedTokens.first, !token.isAtStartOfLine, token.kind != .closingBrace {
                try _parseExpression()
            } else { nil as SyntacticExpression? }
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
    internal func _parseDeclaration() throws(ParsingError) -> SyntacticDeclaration {
        guard let firstToken = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .declaration)
        }
        let accessLevel = switch firstToken.kind {
        case .privateKeyword:
            .private
        case .publicKeyword:
            .public
        default:
            throw .unexpectedToken(firstToken, expected: .accessLevel)
        } as AccessLevel
        let isExternal = _unparsedTokens.first?.kind == .externalKeyword
        if isExternal {
            _unparsedTokens.removeFirst()
        }
        guard let token = _unparsedTokens.popFirst() else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: isExternal ? .externalDeclaration : .declaration)
        }
        switch token.kind {
        case .protocolKeyword where !isExternal:
            let name = try _parseIdentifier()
            let conformances = _unparsedTokens.first?.kind == .colon ? try _parseConformances() : []
            let members = try _parseMembers()
            return .protocol(
                name,
                accessLevel: accessLevel,
                conformances: conformances,
                members: members,
                at: firstToken.location
            )
        case .structureKeyword:
            let name = try _parseIdentifier()
            let conformances = _unparsedTokens.first?.kind == .colon ? try _parseConformances() : []
            let members = try _parseMembers()
            return .structure(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                conformances: conformances,
                members: members,
                at: firstToken.location
            )
        case .constantKeyword:
            let name = try _parseIdentifier()
            try _parseColon()
            let type = try _parseType()
            let hasInitialValue = _unparsedTokens.first?.kind == .equalsSign
            if hasInitialValue {
                _unparsedTokens.removeFirst()
            }
            let initialValue = hasInitialValue ? try _parseExpression() : nil
            return .constant(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                initialValue: initialValue,
                at: firstToken.location
            )
        case .variableKeyword:
            let name = try _parseIdentifier()
            try _parseColon()
            let type = try _parseType()
            let hasInitialValue = _unparsedTokens.first?.kind == .equalsSign
            if hasInitialValue {
                _unparsedTokens.removeFirst()
            }
            let initialValue = hasInitialValue ? try _parseExpression() : nil
            return .variable(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                initialValue: initialValue,
                at: firstToken.location
            )
        case .initializerKeyword where !isExternal:
            let parameters = try _parseParameters()
            let body = _unparsedTokens.first?.kind == .openingBrace ? try _parseBody() : nil
            return .initializer(
                accessLevel: accessLevel,
                parameters: parameters,
                body: body,
                at: firstToken.location
            )
        case .functionKeyword:
            let name = try _parseIdentifier()
            let parameters = try _parseParameters()
            try _parseArrow()
            let returnType = try _parseType()
            let body = _unparsedTokens.first?.kind == .openingBrace ? try _parseBody() : nil
            return .function(
                name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                parameters: parameters,
                returnType: returnType,
                body: body,
                at: firstToken.location
            )
        default:
            throw .unexpectedToken(token, expected: isExternal ? .externalDeclaration : .declaration)
        }
    }
    
    @inlinable
    internal func _parseConformances() throws(ParsingError) -> [SyntacticType] {
        var conformances = [] as [SyntacticType]
        try _parseColon()
        conformances.append(try _parseType())
        while _unparsedTokens.first?.kind == .comma {
            _unparsedTokens.removeFirst()
            conformances.append(try _parseType())
        }
        return conformances
    }
    
    @inlinable
    internal func _parseMembers() throws(ParsingError) -> [SyntacticDeclaration] {
        var members = [] as [SyntacticDeclaration]
        try _parseOpeningBrace()
        while let token = _unparsedTokens.first, token.kind != .closingBrace {
            if !token.isAtStartOfLine, !members.isEmpty {
                throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveDeclarations)
            }
            members.append(try _parseDeclaration())
        }
        try _parseClosingBrace()
        return members
    }
    
    @inlinable
    internal func _parseParameters() throws(ParsingError) -> [SyntacticParameter] {
        var parameters = [] as [SyntacticParameter]
        try _parseOpeningParenthesis()
        while let token = _unparsedTokens.first, token.kind != .closingParenthesis {
            if !parameters.isEmpty {
                try _parseComma()
            }
            parameters.append(try _parseParameter())
        }
        try _parseClosingParenthesis()
        return parameters
    }
    
    @inlinable
    internal func _parseParameter() throws(ParsingError) -> SyntacticParameter {
        guard let firstToken = _unparsedTokens.first else {
            throw .unexpectedEndOfFile(at: _endOfFileLocation, expected: .parameter)
        }
        let label = if case .identifier = _unparsedTokens.dropFirst().first?.kind {
            try _parseIdentifier()
        } else { nil as Identifier? }
        let name = try _parseIdentifier()
        try _parseColon()
        let type = try _parseType()
        let hasDefaultValue = _unparsedTokens.first?.kind == .equalsSign
        if hasDefaultValue {
            _unparsedTokens.removeFirst()
        }
        let defaultValue = hasDefaultValue ? try _parseExpression() : nil
        return SyntacticParameter(name, label: label, type: type, defaultValue: defaultValue, at: firstToken.location)
    }
    
    @inlinable
    internal func _parseBody() throws(ParsingError) -> [SyntacticStatement] {
        var statements = [] as [SyntacticStatement]
        try _parseOpeningBrace()
        while let token = _unparsedTokens.first, token.kind != .closingBrace {
            if !token.isAtStartOfLine, !statements.isEmpty {
                throw .unexpectedToken(token, expected: .newlineSeparatingConsecutiveStatements)
            }
            statements.append(try _parseStatement())
        }
        try _parseClosingBrace()
        return statements
    }
}
