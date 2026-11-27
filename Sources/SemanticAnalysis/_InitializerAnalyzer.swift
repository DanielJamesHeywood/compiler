import Syntax

@usableFromInline
internal final class _InitializerAnalyzer {
    
    @usableFromInline
    internal let _syntacticInitializer: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(for syntacticInitializer: SyntacticDeclaration, in container: _Container) {
        guard case .initializer = syntacticInitializer.kind else {
            preconditionFailure("The declaration is not an initializer declaration")
        }
        self._syntacticInitializer = syntacticInitializer
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticInitializer: SyntacticDeclaration, in protocolAnalyzer: _ProtocolAnalyzer) {
        self.init(for: syntacticInitializer, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticInitializer: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(for: syntacticInitializer, in: _Container(structureAnalyzer))
    }
}
