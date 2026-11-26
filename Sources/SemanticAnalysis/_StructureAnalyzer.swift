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
    internal func declareTypeNames() throws(SemanticAnalysisError) {
        guard case let .structure(_, isExternal: _, conformances: _, members: members) = _syntacticStructure.kind else {
            preconditionFailure("The declaration is not a structure declaration")
        }
    }
}
