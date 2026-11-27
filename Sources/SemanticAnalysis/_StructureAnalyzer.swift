import OrderedCollections

import Tokens
import Syntax

@usableFromInline
internal final class _StructureAnalyzer {
    
    @usableFromInline
    internal let _syntacticStructure: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _protocolAnalyzersForNames = [:] as OrderedDictionary<Identifier, _ProtocolAnalyzer>
    
    @usableFromInline
    internal var _structureAnalyzersForNames = [:] as OrderedDictionary<Identifier, _StructureAnalyzer>
    
    @usableFromInline
    internal var _constantAnalyzersForNames = [:] as OrderedDictionary<Identifier, _ConstantAnalyzer>
    
    @usableFromInline
    internal var _variableAnalyzersForNames = [:] as OrderedDictionary<Identifier, _VariableAnalyzer>
    
    @usableFromInline
    internal var _initializerAnalyzers = [] as [_InitializerAnalyzer]
    
    @usableFromInline
    internal var _functionAnalyzers = [] as [_FunctionAnalyzer]
    
    @usableFromInline
    internal var _functionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _unlabelledFunctionNames = [] as Set<Identifier>
    
    @inlinable
    internal init(_for syntacticStructure: SyntacticDeclaration, in container: _Container) {
        guard case .structure = syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        self._syntacticStructure = syntacticStructure
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticStructure: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(_for: syntacticStructure, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticStructure: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(_for: syntacticStructure, in: _Container(structureAnalyzer))
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard case let .structure(_, isExternal: _, conformances: _, members: members) = _syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        for member in members {
            switch member.kind {
            case let .protocol(name, conformances: _, members: _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name, at: member.location)
                }
                let protocolAnalyzer = _ProtocolAnalyzer(for: member, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, isExternal: _, conformances: _, members: _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name, at: member.location)
                }
                let structureAnalyzer = _StructureAnalyzer(for: member, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal: _, type: _, initialValue: _):
                guard !_hasNonFunctionDeclaration(named: name), !_unlabelledFunctionNames.contains(name) else {
                    throw .invalidRedeclaration(of: name, at: member.location)
                }
                _constantAnalyzersForNames[name] = _ConstantAnalyzer(for: member, in: self)
            case let .variable(name, isExternal: _, type: _, initialValue: _):
                guard !_hasNonFunctionDeclaration(named: name), !_unlabelledFunctionNames.contains(name) else {
                    throw .invalidRedeclaration(of: name, at: member.location)
                }
                _variableAnalyzersForNames[name] = _VariableAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(_InitializerAnalyzer(for: member, in: self))
            case let .function(name, isExternal: _, parameters: parameters, returnType: _, body: _):
                guard !_hasType(named: name), !parameters.isEmpty || !_hasNonFunctionDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name, at: member.location)
                }
                _functionAnalyzers.append(_FunctionAnalyzer(for: member, in: self))
                _functionNames.insert(name)
                if parameters.isEmpty {
                    _unlabelledFunctionNames.insert(name)
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
