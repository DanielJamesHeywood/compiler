import Syntax

public enum SemanticAnalysisError: Error {
    case invalidRedeclaration(SyntacticDeclaration, of: SyntacticDeclaration)
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
