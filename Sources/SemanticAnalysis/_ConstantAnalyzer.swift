import Syntax
import Semantics

@usableFromInline
internal final class _ConstantAnalyzer {
    
    @usableFromInline
    internal let _syntacticConstant: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _semanticConstant: SemanticConstant?
    
    @inlinable
    internal init(
        for syntacticConstant: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        guard case let .constant(_, isExternal, _, _) = syntacticConstant.kind else {
            preconditionFailure("The declaration is not a constant")
        }
        if let syntacticContainer = container._syntacticDeclaration {
            guard !isExternal else {
                fatalError()
            }
            if syntacticContainer.accessLevel == .private, syntacticConstant.accessLevel == .public {
                fatalError()
            }
        }
        self._syntacticConstant = syntacticConstant
        self._container = container
    }
    
    @inlinable
    internal convenience init(
        for syntacticConstant: SyntacticDeclaration,
        in moduleAnalyzer: _ModuleAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticConstant, in: _Container(moduleAnalyzer))
    }
}
