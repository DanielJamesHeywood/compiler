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
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let protocolAnalyzer = try _ProtocolAnalyzer(for: declaration, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasPublicDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _analyzer._publicProtocolAnalyzersForNames[name] = protocolAnalyzer
                }
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, _, _, _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let structureAnalyzer = try _StructureAnalyzer(for: declaration, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasPublicDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _analyzer._publicStructureAnalyzersForNames[name] = structureAnalyzer
                }
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal, _, _):
                guard !_hasUnlabeledDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let constantAnalyzer = try _ConstantAnalyzer(for: declaration, in: self)
                _constantAnalyzersForNames[name] = constantAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasPublicUnlabeledDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _analyzer._publicConstantAnalyzersForNames[name] = constantAnalyzer
                }
                if isExternal {
                    try _analyzer._insertExternalName(name)
                }
            case let .variable(name, isExternal, _, _):
                guard !_hasUnlabeledDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let variableAnalyzer = try _VariableAnalyzer(for: declaration, in: self)
                _variableAnalyzersForNames[name] = variableAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasPublicUnlabeledDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _analyzer._publicVariableAnalyzersForNames[name] = variableAnalyzer
                }
                if isExternal {
                    try _analyzer._insertExternalName(name)
                }
            case .initializer:
                fatalError()
            case let .function(name, isExternal, parameters, _, _):
                guard !_hasTypeDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                _functionAnalyzers.append(try _FunctionAnalyzer(for: declaration, in: self))
                _functionNames.insert(name)
                if parameters.isEmpty {
                    guard !_hasConstantOrVariable(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _unlabeledFunctionNames.insert(name)
                }
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasPublicTypeDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _analyzer._publicFunctionNames.insert(name)
                    if parameters.isEmpty {
                        guard !_analyzer._hasPublicConstantOrVariable(named: name) else {
                            throw .invalidRedeclaration(of: name)
                        }
                        _analyzer._publicUnlabeledFunctionNames.insert(name)
                    }
                }
                if isExternal {
                    try _analyzer._insertExternalName(name)
                }
            }
        }
    }
    
    @inlinable
    internal func _hasDeclaration(named name: Identifier) -> Bool {
        _hasTypeDeclaration(named: name) || _hasConstantOrVariable(named: name) || _hasFunction(named: name)
    }
    
    @inlinable
    internal func _hasUnlabeledDeclaration(named name: Identifier) -> Bool {
        _hasTypeDeclaration(named: name) || _hasConstantOrVariable(named: name) || _hasUnlabeledFunction(named: name)
    }
    
    @inlinable
    internal func _hasTypeDeclaration(named name: Identifier) -> Bool {
        _protocolAnalyzersForNames.keys.contains(name) || _structureAnalyzersForNames.keys.contains(name)
    }
    
    @inlinable
    internal func _hasConstantOrVariable(named name: Identifier) -> Bool {
        _constantAnalyzersForNames.keys.contains(name) || _variableAnalyzersForNames.keys.contains(name)
    }
    
    @inlinable
    internal func _hasFunction(named name: Identifier) -> Bool {
        _functionNames.contains(name)
    }
    
    @inlinable
    internal func _hasUnlabeledFunction(named name: Identifier) -> Bool {
        _unlabeledFunctionNames.contains(name)
    }
}
