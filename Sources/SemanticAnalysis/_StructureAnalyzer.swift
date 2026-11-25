import Tokens
import Semantics

@usableFromInline
internal final class _StructureAnalyzer {
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _structureAnalyzers = [] as [_StructureAnalyzer]
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(_in container: _Container) {
        self._container = container
    }
    
    @inlinable
    internal convenience init(in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(_in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(in structureAnalyzer: _StructureAnalyzer) {
        self.init(_in: _Container(structureAnalyzer))
    }
}
