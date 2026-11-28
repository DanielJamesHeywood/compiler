import OrderedCollections

import Tokens
import Syntax
import Semantics

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
    internal var _propertyAnalyzersForNames = [:] as OrderedDictionary<Identifier, _PropertyAnalyzer>
    
    @usableFromInline
    internal var _initializerAnalyzers = [] as [_InitializerAnalyzer]
    
    @usableFromInline
    internal var _functionAnalyzers = [] as [_FunctionAnalyzer]
    
    @usableFromInline
    internal var _functionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _unlabeledFunctionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _semanticStructure: SemanticStructure?
    
    @inlinable
    internal init(
        for syntacticStructure: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        guard case let .structure(_, isExternal, _, _) = syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        if let syntacticContainer = container._syntacticDeclaration {
            guard !isExternal else {
                fatalError()
            }
            if syntacticContainer.accessLevel == .private, syntacticStructure.accessLevel == .public {
                fatalError()
            }
        }
        self._syntacticStructure = syntacticStructure
        self._container = container
    }
    
    @inlinable
    internal convenience init(
        for syntacticStructure: SyntacticDeclaration,
        in moduleAnalyzer: _ModuleAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticStructure, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(
        for syntacticStructure: SyntacticDeclaration,
        in structureAnalyzer: _StructureAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticStructure, in: _Container(structureAnalyzer))
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard case let .structure(_, _, _, members) = _syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        for member in members {
            switch member.kind {
            case let .protocol(name, _, _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let protocolAnalyzer = try _ProtocolAnalyzer(for: member, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, _, _, _):
                guard !_hasDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                let structureAnalyzer = try _StructureAnalyzer(for: member, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, _, _, _), let .variable(name, _, _, _):
                guard !_hasUnlabeledDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                _propertyAnalyzersForNames[name] = try _PropertyAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(try _InitializerAnalyzer(for: member, in: self))
            case let .function(name, _, parameters, _, _):
                guard !_hasTypeDeclaration(named: name) else {
                    throw .invalidRedeclaration(of: name)
                }
                _functionAnalyzers.append(try _FunctionAnalyzer(for: member, in: self))
                _functionNames.insert(name)
                if parameters.isEmpty {
                    guard !_hasConstantOrVariable(named: name) else {
                        throw .invalidRedeclaration(of: name)
                    }
                    _unlabeledFunctionNames.insert(name)
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
        _propertyAnalyzersForNames.keys.contains(name)
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
