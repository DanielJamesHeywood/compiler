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
    
    @usableFromInline
    internal var _functionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _unlabeledFunctionNames = [] as Set<Identifier>
    
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
            case let .protocol(name, _, _):
                let protocolAnalyzer = try _ProtocolAnalyzer(for: declaration, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, _, _, _):
                let structureAnalyzer = try _StructureAnalyzer(for: declaration, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal, _, _):
                _constantAnalyzersForNames[name] = try _ConstantAnalyzer(for: declaration, in: self)
                if isExternal {
                    guard !_analyzer._externalNames.contains(name) else {
                        fatalError()
                    }
                    _analyzer._externalNames.insert(name)
                }
            case let .variable(name, isExternal, _, _):
                _variableAnalyzersForNames[name] = try _VariableAnalyzer(for: declaration, in: self)
                if isExternal {
                    guard !_analyzer._externalNames.contains(name) else {
                        fatalError()
                    }
                    _analyzer._externalNames.insert(name)
                }
            case .initializer:
                fatalError()
            case let .function(name, isExternal, parameters, _, _):
                _functionAnalyzers.append(try _FunctionAnalyzer(for: declaration, in: self))
                _functionNames.insert(name)
                if parameters.isEmpty {
                    _unlabeledFunctionNames.insert(name)
                }
                if isExternal {
                    guard !_analyzer._externalNames.contains(name) else {
                        fatalError()
                    }
                    _analyzer._externalNames.insert(name)
                }
            }
        }
    }
}
