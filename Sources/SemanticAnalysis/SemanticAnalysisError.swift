import Syntax

public enum SemanticAnalysisError: Hashable, Error {
    case invalidRedeclaration(SyntacticDeclaration, of: SyntacticDeclaration)
}
