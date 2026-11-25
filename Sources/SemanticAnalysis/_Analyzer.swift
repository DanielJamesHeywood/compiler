import Tokens
import Semantics

@usableFromInline
internal final class _Analyzer {
    
    @usableFromInline
    internal var _moduleAnalyzers = [] as [_ModuleAnalyzer]
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init() {}
    
    @inlinable
    internal func takeSemanticStructures() -> [SemanticStructure] { [] }
    
    @inlinable
    internal func takeSemanticConstants() -> [SemanticConstant] { [] }
    
    @inlinable
    internal func takeSemanticVariables() -> [SemanticVariable] { [] }
    
    @inlinable
    internal func takeSemanticFunctions() -> [SemanticFunction] { [] }
}
