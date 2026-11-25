import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _ModuleAnalyzer {
    
    @usableFromInline
    internal let _syntacticModule: SyntacticModule
    
    @usableFromInline
    internal weak let _analyzer: _Analyzer?
    
    @usableFromInline
    internal var _structureAnalyzers = [] as [_StructureAnalyzer]
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(for syntacticModule: SyntacticModule, in analyzer: _Analyzer) {
        self._syntacticModule = syntacticModule
        self._analyzer = analyzer
    }
}
