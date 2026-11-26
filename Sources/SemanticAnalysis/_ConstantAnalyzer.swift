import Syntax

@usableFromInline
internal final class _ConstantAnalyzer {
    
    @usableFromInline
    internal let _syntacticConstant: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(_for syntacticConstant: SyntacticDeclaration, in container: _Container) {
        guard case .constant = syntacticConstant.kind else {
            preconditionFailure("The declaration is not a constant")
        }
        self._syntacticConstant = syntacticConstant
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticConstant: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(_for: syntacticConstant, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticConstant: SyntacticDeclaration, in protocolAnalyzer: _ProtocolAnalyzer) {
        self.init(_for: syntacticConstant, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticConstant: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(_for: syntacticConstant, in: _Container(structureAnalyzer))
    }
}
