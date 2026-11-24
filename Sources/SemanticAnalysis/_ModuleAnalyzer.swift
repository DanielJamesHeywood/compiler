import Tokens
import Semantics

@usableFromInline
internal final class _ModuleAnalyzer {
    
    @usableFromInline
    internal weak let _analyzer: _Analyzer?
    
    @usableFromInline
    internal var _structureAnalyzers = [] as [_StructureAnalyzer]
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(in analyzer: _Analyzer) {
        self._analyzer = analyzer
    }
}
