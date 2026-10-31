import Tokens

@inlinable
public func tokens(for text: String) throws(LexingError) -> [Token] {
    var tokens = [] as [Token]
    for (lineNumber, line) in zip(1..., text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)) {
        var columnNumber = 1
        var unlexedText = line.prefix(upTo: line.firstRange(of: "//")?.lowerBound ?? line.endIndex)
        var isAtStartOfLine = true
        while let character = unlexedText.first {
            if character.isWhitespace {
                columnNumber += 1
                unlexedText.removeFirst()
            } else {
                let token: Token
                let location = SourceLocation(line: lineNumber, column: columnNumber)
                if let match = unlexedText.prefixMatch(
                    of: /[a-zA-Z_][a-zA-Z_0-9]*/
                ) {
                    token = switch match.output {
                    case "constant":
                        .constantKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "external":
                        .externalKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "function":
                        .functionKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "initializer":
                        .initializerKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "private":
                        .privateKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "public":
                        .publicKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "return":
                        .returnKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "self":
                        .selfKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "structure":
                        .structureKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "variable":
                        .variableKeyword(isAtStartOfLine: isAtStartOfLine, at: location)
                    default:
                        .identifier(match.output, isAtStartOfLine: isAtStartOfLine, at: location)
                    }
                } else if let match = unlexedText.prefixMatch(
                    of: /-?(?:0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9a-fA-F][0-9a-fA-F_]*|[0-9][0-9_]*)/
                ) {
                    token = .integerLiteral(match.output, isAtStartOfLine: isAtStartOfLine, at: location)
                } else {
                    token = switch character {
                    case "(":
                        .openingParenthesis(isAtStartOfLine: isAtStartOfLine, at: location)
                    case ")":
                        .closingParenthesis(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "{":
                        .openingBrace(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "}":
                        .closingBrace(isAtStartOfLine: isAtStartOfLine, at: location)
                    case ".":
                        .period(isAtStartOfLine: isAtStartOfLine, at: location)
                    case ",":
                        .comma(isAtStartOfLine: isAtStartOfLine, at: location)
                    case ":":
                        .colon(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "=":
                        .equalsSign(isAtStartOfLine: isAtStartOfLine, at: location)
                    case "-" where unlexedText.hasPrefix("->"):
                        .arrow(isAtStartOfLine: isAtStartOfLine, at: location)
                    default:
                        throw .unexpectedCharacter(character, at: location)
                    }
                }
                columnNumber += token.text.count
                unlexedText.trimPrefix(token.text)
                isAtStartOfLine = false
                tokens.append(token)
            }
        }
    }
    return tokens
}
