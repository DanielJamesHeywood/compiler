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
    internal init(for syntacticProtocol: SyntacticDeclaration, in container: _Container) {
        guard case .protocol = syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        self._syntacticProtocol = syntacticProtocol
        self._container = container
    }
    
    @inlinable
    internal convenience init(for syntacticProtocol: SyntacticDeclaration, in moduleAnalyzer: _ModuleAnalyzer) {
        self.init(for: syntacticProtocol, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(for syntacticProtocol: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {
        self.init(for: syntacticProtocol, in: _Container(structureAnalyzer))
    }
    
    @inlinable
    internal func registerDeclarations() throws(SemanticAnalysisError) {
        guard case let .protocol(_, _, members) = _syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        for member in members {
            switch member.kind {
            case .protocol, .structure:
                fatalError()
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
