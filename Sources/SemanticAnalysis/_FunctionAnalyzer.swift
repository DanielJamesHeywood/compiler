import Tokens
import Syntax

@usableFromInline
internal final class _FunctionAnalyzer {
    
    @usableFromInline
    internal let _syntacticFunction: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(for syntacticFunction: SyntacticDeclaration, in container: _Container) {
        guard case .function = syntacticFunction.kind else {
            preconditionFailure("The declaration is not a function declaration")
        }
        self._syntacticFunction = syntacticFunction
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticFunction: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(for: syntacticFunction, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticFunction: SyntacticDeclaration, in protocolAnalyzer: _ProtocolAnalyzer) {
        self.init(for: syntacticFunction, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticFunction: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(for: syntacticFunction, in: _Container(structureAnalyzer))
    }
}
