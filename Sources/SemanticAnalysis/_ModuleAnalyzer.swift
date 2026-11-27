import OrderedCollections

import Tokens
import Syntax

@usableFromInline
internal final class _ModuleAnalyzer {
    
    @usableFromInline
    internal let _syntacticModule: SyntacticModule
    
    @usableFromInline
    internal weak let _analyzer: _Analyzer?
    
    @usableFromInline
    internal var _protocolAnalyzersForNames = [:] as OrderedDictionary<Identifier, _ProtocolAnalyzer>
    
    @usableFromInline
    internal var _structureAnalyzersForNames = [:] as OrderedDictionary<Identifier, _StructureAnalyzer>
    
    @usableFromInline
    internal var _constantAnalyzersForNames = [:] as OrderedDictionary<Identifier, _ConstantAnalyzer>
    
    @usableFromInline
    internal var _variableAnalyzersForNames = [:] as OrderedDictionary<Identifier, _VariableAnalyzer>
    
    @usableFromInline
    internal var _functionAnalyzers = [] as [_FunctionAnalyzer]
    
    @inlinable
    internal init(for syntacticModule: SyntacticModule, in analyzer: _Analyzer) {
        self._syntacticModule = syntacticModule
        self._analyzer = analyzer
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard let _analyzer else {
            preconditionFailure("The analyzer has been deallocated")
        }
        for declaration in _syntacticModule.declarations {
            switch declaration.kind {
            case let .protocol(name, conformances: _, members: _):
                let protocolAnalyzer = _ProtocolAnalyzer(for: declaration, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, isExternal: _, conformances: _, members: _):
                let structureAnalyzer = _StructureAnalyzer(for: declaration, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal: isExternal, type: _, initialValue: _):
                let constantAnalyzer = _ConstantAnalyzer(for: declaration, in: self)
                _constantAnalyzersForNames[name] = constantAnalyzer
            case let .variable(name, isExternal: isExternal, type: _, initialValue: _):
                let variableAnalyzer = _VariableAnalyzer(for: declaration, in: self)
                _variableAnalyzersForNames[name] = variableAnalyzer
            case .initializer:
                break
            case let .function(name, isExternal: isExternal, parameters: _, returnType: _, body: _):
                _functionAnalyzers.append(_FunctionAnalyzer(for: declaration, in: self))
            }
        }
    }
}
