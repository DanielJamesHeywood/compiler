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
    
    @usableFromInline
    internal var _unlabeledFunctionNames = [] as Set<Identifier>
    
    @inlinable
    internal init(
        for syntacticProtocol: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        guard case .protocol = syntacticProtocol.kind else {
            preconditionFailure("The declaration is not a protocol declaration")
        }
        if let syntacticContainer = container._syntacticDeclaration {
            if syntacticContainer.accessLevel == .private, syntacticProtocol.accessLevel == .public {
                fatalError()
            }
        }
        self._syntacticProtocol = syntacticProtocol
        self._container = container
    }
    
    @inlinable
    internal convenience init(
        for syntacticProtocol: SyntacticDeclaration,
        in moduleAnalyzer: _ModuleAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticProtocol, in: _Container(moduleAnalyzer))
    }
    
    @inlinable
    internal convenience init(
        for syntacticProtocol: SyntacticDeclaration,
        in structureAnalyzer: _StructureAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticProtocol, in: _Container(structureAnalyzer))
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
            case let .constant(name, _, _, _), let .variable(name, _, _, _):
                guard false else {
                    fatalError()
                }
                _propertyAnalyzersForNames[name] = try _PropertyAnalyzer(for: member, in: self)
            case .initializer:
                _initializerAnalyzers.append(try _InitializerAnalyzer(for: member, in: self))
            case let .function(name, _, parameters, _, _):
                guard false else {
                    fatalError()
                }
                _functionAnalyzers.append(try _FunctionAnalyzer(for: member, in: self))
                if parameters.isEmpty {
                    _unlabeledFunctionNames.insert(name)
                }
            }
        }
    }
}
