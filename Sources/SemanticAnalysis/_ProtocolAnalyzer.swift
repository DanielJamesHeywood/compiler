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
    internal var _constantAnalyzersForNames = [:] as OrderedDictionary<Identifier, _ConstantAnalyzer>
    
    @usableFromInline
    internal var _variableAnalyzersForNames = [:] as OrderedDictionary<Identifier, _VariableAnalyzer>
    
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
        guard case let .protocol(_, conformances: _, members: members) = _syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        for member in members {
        }
    }
}
