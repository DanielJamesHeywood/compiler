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
    
    @inlinable
    internal init(for syntacticStructure: SyntacticDeclaration, in container: _Container) {
        guard case .structure = syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        self._syntacticStructure = syntacticStructure
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticStructure: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(for: syntacticStructure, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticStructure: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(for: syntacticStructure, in: _Container(structureAnalyzer))
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard case let .structure(_, _, _, members) = _syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
        for member in members {
            switch member.kind {
            case let .protocol(name, _, _):
                let protocolAnalyzer = _ProtocolAnalyzer(for: member, in: self)
                _protocolAnalyzersForNames[name] = protocolAnalyzer
                try protocolAnalyzer.registerDeclarations()
            case let .structure(name, isExternal, _, _):
                guard !isExternal else {
                    fatalError()
                }
                let structureAnalyzer = _StructureAnalyzer(for: member, in: self)
                _structureAnalyzersForNames[name] = structureAnalyzer
                try structureAnalyzer.registerDeclarations()
            case let .constant(name, isExternal, _, _), let .variable(name, isExternal, _, _):
                guard !isExternal else {
                    fatalError()
                }
                _propertyAnalyzersForNames[name] = _PropertyAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(_InitializerAnalyzer(for: member, in: self))
            case let .function(name, isExternal, parameters, _, _):
                guard !isExternal else {
                    fatalError()
                }
                _functionAnalyzers.append(_FunctionAnalyzer(for: member, in: self))
            }
        }
    }
}
