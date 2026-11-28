import Syntax
import Semantics

@usableFromInline
internal final class _VariableAnalyzer {
    
    @usableFromInline
    internal let _syntacticVariable: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _semanticVariable: SemanticVariable?
    
    @inlinable
    internal init(
        for syntacticVariable: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        guard case let .variable(_, isExternal, _, _) = syntacticVariable.kind else {
            preconditionFailure("The declaration is not a variable")
        }
        if let syntacticContainer = container._syntacticDeclaration {
            guard !isExternal else {
                fatalError()
            }
            if syntacticContainer.accessLevel == .private, syntacticVariable.accessLevel == .public {
                fatalError()
            }
        }
        self._syntacticVariable = syntacticVariable
        self._container = container
    }
    
    @inlinable
    internal convenience init(
        for syntacticVariable: SyntacticDeclaration,
        in moduleAnalyzer: _ModuleAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticVariable, in: _Container(moduleAnalyzer))
    }
}
