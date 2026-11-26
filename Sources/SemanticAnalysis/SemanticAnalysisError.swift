import Syntax

public enum SemanticAnalysisError: Error {
    case invalidRedeclaration(SyntacticDeclaration, of: SyntacticDeclaration)
}

extension SemanticAnalysisError: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticAnalysisError, rhs: SemanticAnalysisError) -> Bool {
        switch (lhs, rhs) {
        case let (
            .invalidRedeclaration(lhDeclaration, of: otherLHDeclaration),
            .invalidRedeclaration(rhDeclaration, of: otherRHDeclaration)
        ):
            lhDeclaration == rhDeclaration
                && lhDeclaration.location == rhDeclaration.location
                && otherLHDeclaration == otherRHDeclaration
                && otherLHDeclaration.location == otherRHDeclaration.location
        }
    }
}

extension SemanticAnalysisError: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .invalidRedeclaration(declaration, of: otherDeclaration):
            hasher.combine(declaration)
            hasher.combine(declaration.location)
            hasher.combine(otherDeclaration)
            hasher.combine(otherDeclaration.location)
        }
    }
}

extension SemanticAnalysisError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        let caseDescription = switch self {
        case let .invalidRedeclaration(declaration, of: otherDeclaration):
            "invalidRedeclaration(\(String(reflecting: declaration)), of: \(String(reflecting: otherDeclaration)))"
        }
        return "SemanticAnalysis.SemanticAnalysisError.\(caseDescription)"
    }
}
