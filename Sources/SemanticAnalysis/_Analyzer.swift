import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _Analyzer {
    
    @usableFromInline
    internal var _moduleAnalyzers = [] as [_ModuleAnalyzer]
    
    @usableFromInline
    internal var _publicProtocolAnalyzersForNames = [:] as [Identifier: _ProtocolAnalyzer]
    
    @usableFromInline
    internal var _publicStructureAnalyzersForNames = [:] as [Identifier: _StructureAnalyzer]
    
    @usableFromInline
    internal var _publicConstantAnalyzersForNames = [:] as [Identifier: _ConstantAnalyzer]
    
    @usableFromInline
    internal var _publicVariableAnalyzersForNames = [:] as [Identifier: _VariableAnalyzer]
    
    @usableFromInline
    internal var _publicFunctionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _publicUnlabeledFunctionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _externalNames = [] as Set<Identifier>
    
    @inlinable
    internal init(for syntacticModules: [SyntacticModule]) {
        let syntacticModules = [_syntacticStandardLibrary] + syntacticModules
        self._moduleAnalyzers = syntacticModules.map { syntacticModule in
            _ModuleAnalyzer(for: syntacticModule, in: self)
        }
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        for moduleAnalyzer in _moduleAnalyzers {
            try moduleAnalyzer.registerDeclarations()
        }
    }
    
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
