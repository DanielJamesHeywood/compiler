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
    internal var _unlabelledFunctionNames = [] as Set<Identifier>
    
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
                    throw .invalidRedeclaration(of: name, at: declaration.location)
                }
                let protocolAnalyzer = _ProtocolAnalyzer(for: declaration, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._protocolAnalyzersForNames[name] = protocolAnalyzer
                }
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, _, _, _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name, at: declaration.location)
                }
                let structureAnalyzer = _StructureAnalyzer(for: declaration, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                if declaration.accessLevel == .public {
                    guard !_analyzer._hasDeclaration(named: name) else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._structureAnalyzersForNames[name] = structureAnalyzer
                }
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal, _, _):
                guard !_hasNonFunctionDeclaration(named: name), !_unlabelledFunctionNames.contains(name) else {
                    throw .invalidRedeclaration(of: name, at: declaration.location)
                }
                let constantAnalyzer = _ConstantAnalyzer(for: declaration, in: self)
                _constantAnalyzersForNames[name] = constantAnalyzer
                if declaration.accessLevel == .public {
                    guard
                        !_analyzer._hasNonFunctionDeclaration(named: name),
                        !_analyzer._unlabelledFunctionNames.contains(name)
                    else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._constantAnalyzersForNames[name] = constantAnalyzer
                }
                if isExternal {
                    guard _analyzer._externalNames.contains(name) else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._externalNames.insert(name)
                }
            case let .variable(name, isExternal, _, _):
                guard !_hasNonFunctionDeclaration(named: name), !_unlabelledFunctionNames.contains(name) else {
                    throw .invalidRedeclaration(of: name, at: declaration.location)
                }
                let variableAnalyzer = _VariableAnalyzer(for: declaration, in: self)
                _variableAnalyzersForNames[name] = variableAnalyzer
                if declaration.accessLevel == .public {
                    guard
                        !_analyzer._hasNonFunctionDeclaration(named: name),
                        !_analyzer._unlabelledFunctionNames.contains(name)
                    else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._variableAnalyzersForNames[name] = variableAnalyzer
                }
                if isExternal {
                    guard _analyzer._externalNames.contains(name) else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._externalNames.insert(name)
                }
            case .initializer:
                throw .initializerOutsideType(at: declaration.location)
            case let .function(name, isExternal: isExternal, parameters: parameters, returnType: _, body: _):
                guard !_hasType(named: name), !parameters.isEmpty || !_hasNonFunctionDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name, at: declaration.location)
                }
                _functionAnalyzers.append(_FunctionAnalyzer(for: declaration, in: self))
                _functionNames.insert(name)
                if parameters.isEmpty {
                    _unlabelledFunctionNames.insert(name)
                }
                if declaration.accessLevel == .public {
                    guard
                        !_analyzer._hasType(named: name),
                        !parameters.isEmpty || !_analyzer._hasNonFunctionDeclaration(named: name)
                    else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._functionNames.insert(name)
                    if parameters.isEmpty {
                        _analyzer._unlabelledFunctionNames.insert(name)
                    }
                }
                if isExternal {
                    guard _analyzer._externalNames.contains(name) else {
                        throw .invalidRedeclaration(of: name, at: declaration.location)
                    }
                    _analyzer._externalNames.insert(name)
                }
            }
        }
    }
    
    @inlinable
    internal func _hasDeclaration(named name: Identifier) -> Bool {
        _hasNonFunctionDeclaration(named: name) || _functionNames.contains(name)
    }
    
    @inlinable
    internal func _hasNonFunctionDeclaration(named name: Identifier) -> Bool {
        _hasType(named: name)
            || _constantAnalyzersForNames.keys.contains(name)
            || _variableAnalyzersForNames.keys.contains(name)
    }
    
    @inlinable
    internal func _hasType(named name: Identifier) -> Bool {
        _protocolAnalyzersForNames.keys.contains(name) || _structureAnalyzersForNames.keys.contains(name)
    }
}
