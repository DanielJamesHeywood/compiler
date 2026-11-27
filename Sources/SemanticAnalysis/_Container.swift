import Syntax
import Semantics

@usableFromInline
internal enum _Container {
    case moduleAnalyzer(Weak<_ModuleAnalyzer>)
    case protocolAnalyzer(Weak<_ProtocolAnalyzer>)
    case structureAnalyzer(Weak<_StructureAnalyzer>)
}

extension _Container {
    
    @inlinable
    internal init(_ moduleAnalyzer: _ModuleAnalyzer) {
        self = .moduleAnalyzer(Weak(moduleAnalyzer))
    }
    
    @inlinable
    internal init(_ protocolAnalyzer: _ProtocolAnalyzer) {
        self = .protocolAnalyzer(Weak(protocolAnalyzer))
    }
    
    @inlinable
    internal init(_ structureAnalyzer: _StructureAnalyzer) {
        self = .structureAnalyzer(Weak(structureAnalyzer))
    }
    
    @inlinable
    internal var _syntacticDeclaration: SyntacticDeclaration? {
        switch self {
        case .moduleAnalyzer:
            return nil
        case let .protocolAnalyzer(protocolAnalyzer):
            guard let protocolAnalyzer = protocolAnalyzer.object else {
                preconditionFailure("The protocol analyzer has been deallocated")
            }
            return protocolAnalyzer._syntacticProtocol
        case let .structureAnalyzer(structureAnalyzer):
            guard let structureAnalyzer = structureAnalyzer.object else {
                preconditionFailure("The structure analyzer has been deallocated")
            }
            return structureAnalyzer._syntacticStructure
        }
    }
}
