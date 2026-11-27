import SystemPackage

import Tokens

public struct SemanticAnalysisError: Hashable, Error {
    
    public enum Kind: Hashable, Sendable {
        case invalidRedeclaration(of: Identifier)
        case initializerOutsideType
        case typeNestedInProtocol(named: Identifier)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation?) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func invalidRedeclaration(of name: Identifier, at location: SourceLocation?) -> SemanticAnalysisError {
        SemanticAnalysisError(_kind: .invalidRedeclaration(of: name), at: location)
    }
    
    @inlinable
    public static func initializerOutsideType(at location: SourceLocation?) -> SemanticAnalysisError {
        SemanticAnalysisError(_kind: .initializerOutsideType, at: location)
    }
    
    @inlinable
    public static func typeNestedInProtocol(
        named name: Identifier,
        at location: SourceLocation?
    ) -> SemanticAnalysisError {
        SemanticAnalysisError(_kind: .typeNestedInProtocol(named: name), at: location)
    }
}

extension SemanticAnalysisError: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        let message = switch kind {
        case let .invalidRedeclaration(of: name):
            "Invalid redeclaration of '\(name)'"
        case .initializerOutsideType:
            "Initializers can only be declared in a type"
        case let .typeNestedInProtocol(named: name):
            "Type '\(name)' cannot be nested in a protocol"
        }
        guard let location else {
            return message
        }
        return "\(message) at line \(location.line), column \(location.column) in \(location.path)"
    }
}

extension SemanticAnalysisError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        let kindDescription = String(reflecting: kind)
        let locationDescription = String(reflecting: location)
        return "SemanticAnalysis.SemanticAnalysisError(kind: \(kindDescription), location: \(locationDescription))"
    }
}
