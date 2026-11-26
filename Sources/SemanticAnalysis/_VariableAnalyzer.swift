import Syntax

@usableFromInline
internal final class _VariableAnalyzer {
    
    @usableFromInline
    internal let _syntacticVariable: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(_for syntacticVariable: SyntacticDeclaration, in container: _Container) {
        guard case .variable = syntacticVariable.kind else {
            preconditionFailure("The declaration is not a variable")
        }
        self._syntacticVariable = syntacticVariable
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticVariable: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(_for: syntacticVariable, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticVariable: SyntacticDeclaration, in protocolAnalyzer: _ProtocolAnalyzer) {
        self.init(_for: syntacticVariable, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticVariable: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(_for: syntacticVariable, in: _Container(structureAnalyzer))
    }
}
