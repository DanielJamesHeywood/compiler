import Syntax

@usableFromInline
internal final class _FunctionAnalyzer {
    
    @usableFromInline
    internal let _syntacticFunction: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(
        for syntacticFunction: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        guard case let .function(_, isExternal, _, _, _) = syntacticFunction.kind else {
            preconditionFailure("The declaration is not a function declaration")
        }
        if let syntacticContainer = container._syntacticDeclaration {
            guard !isExternal else {
                fatalError()
            }
            if syntacticContainer.accessLevel == .private, syntacticFunction.accessLevel == .public {
                fatalError()
            }
        }
        self._syntacticFunction = syntacticFunction
        self._container = container
    }
    
    @inlinable
    internal convenience init(
        for syntacticFunction: SyntacticDeclaration,
        in moduleAnalyzer: _ModuleAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticFunction, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(
        for syntacticFunction: SyntacticDeclaration,
        in protocolAnalyzer: _ProtocolAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticFunction, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal convenience init(
        for syntacticFunction: SyntacticDeclaration,
        in structureAnalyzer: _StructureAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticFunction, in: _Container(structureAnalyzer))
    }
}
