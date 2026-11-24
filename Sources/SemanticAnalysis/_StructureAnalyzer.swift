import Tokens
import Semantics

@usableFromInline
internal final class _StructureAnalyzer {
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(in container: _Container) {
        self._container = container
    }
}
