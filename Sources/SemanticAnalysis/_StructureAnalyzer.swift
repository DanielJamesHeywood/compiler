import Tokens
import Semantics

@usableFromInline
internal final class _StructureAnalyzer {
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(in moduleAnalyzer: _ModuleAnalyzer) {
        self._container = _Container(moduleAnalyzer)
    }
    
    @inlinable
    internal init(in structureAnalyzer: _StructureAnalyzer) {
        self._container = _Container(structureAnalyzer)
    }
}
