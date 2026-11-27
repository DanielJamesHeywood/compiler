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
    internal var _propertyAnalyzersForNames = [:] as OrderedDictionary<Identifier, _PropertyAnalyzer>
    
    @usableFromInline
    internal var _initializerAnalyzers = [] as [_InitializerAnalyzer]
    
    @usableFromInline
    internal var _functionAnalyzers = [] as [_FunctionAnalyzer]
    
    @usableFromInline
    internal var _functionNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _unlabeledFunctionNames = [] as Set<Identifier>
    
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
                let protocolAnalyzer = try _ProtocolAnalyzer(for: member, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, _, _, _):
                let structureAnalyzer = try _StructureAnalyzer(for: member, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, _, _, _), let .variable(name, _, _, _):
                _propertyAnalyzersForNames[name] = try _PropertyAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(try _InitializerAnalyzer(for: member, in: self))
            case let .function(name, _, parameters, _, _):
                _functionAnalyzers.append(try _FunctionAnalyzer(for: member, in: self))
            }
        }
    }
}
