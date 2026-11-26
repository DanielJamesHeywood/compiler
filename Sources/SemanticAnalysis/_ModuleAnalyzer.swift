import OrderedCollections

import Tokens
import Syntax
import Semantics

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
    
    @inlinable
    internal init(for syntacticModule: SyntacticModule, in analyzer: _Analyzer) {
        self._syntacticModule = syntacticModule
        self._analyzer = analyzer
        self._protocolAnalyzers = syntacticModule.declarations.compactMap { declaration in
            if case .protocol = declaration.kind { _ProtocolAnalyzer(for: declaration, in: self) } else { nil }
        }
        self._structureAnalyzers = syntacticModule.declarations.compactMap { declaration in
            if case .structure = declaration.kind { _StructureAnalyzer(for: declaration, in: self) } else { nil }
        }
    }
}
