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
}
