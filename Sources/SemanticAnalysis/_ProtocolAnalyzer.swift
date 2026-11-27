import OrderedCollections

import Tokens
import Syntax

@usableFromInline
internal final class _ProtocolAnalyzer {
    
    @usableFromInline
    internal let _syntacticProtocol: SyntacticDeclaration
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _propertyAnalyzersForNames = [:] as OrderedDictionary<Identifier, _PropertyAnalyzer>
    
    @usableFromInline
    internal var _initializerAnalyzers = [] as [_InitializerAnalyzer]
    
    @usableFromInline
    internal var _functionAnalyzers = [] as [_FunctionAnalyzer]
    
    @inlinable
    internal init(_for syntacticProtocol: SyntacticDeclaration, in container: _Container) {
        guard case .protocol = syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        self._syntacticProtocol = syntacticProtocol
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticProtocol: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(_for: syntacticProtocol, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticProtocol: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(_for: syntacticProtocol, in: _Container(structureAnalyzer))
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard case let .protocol(_, _, members) = _syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        for member in members {
            switch member.kind {
            case let .protocol(name, _, _), let .structure(name, _, _, _):
                throw .typeNestedInProtocol(named: name, at: member.location)
            case let .constant(name, _, _, _), let .variable(name, _, _, _):
                _propertyAnalyzersForNames[name] = _PropertyAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(_InitializerAnalyzer(for: member, in: self))
            case let .function(name, _, parameters, _, _):
                _functionAnalyzers.append(_FunctionAnalyzer(for: member, in: self))
            }
        }
    }
}
