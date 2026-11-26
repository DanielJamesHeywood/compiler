import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _Analyzer {
    
    @usableFromInline
    internal var _moduleAnalyzers = [] as [_ModuleAnalyzer]
    
    @usableFromInline
    internal var _semanticProtocolsForNames = [:] as [Identifier: SemanticProtocol]
    
    @usableFromInline
    internal var _semanticStructuresForNames = [:] as [Identifier: SemanticStructure]
    
    @inlinable
    internal init(for syntacticModules: [SyntacticModule]) {}
    
    @inlinable
    internal func takeSemanticProtocols() -> [SemanticProtocol] { [] }
    
    @inlinable
    internal func takeSemanticStructures() -> [SemanticStructure] { [] }
    
    @inlinable
    internal func takeSemanticConstants() -> [SemanticConstant] { [] }
    
    @inlinable
    internal func takeSemanticVariables() -> [SemanticVariable] { [] }
    
    @inlinable
    internal func takeSemanticFunctions() -> [SemanticFunction] { [] }
}
