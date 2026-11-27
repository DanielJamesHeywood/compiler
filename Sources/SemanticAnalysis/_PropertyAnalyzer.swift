import Syntax

@usableFromInline
internal enum _PropertyAnalyzer {
    case constantAnalyzer(_ConstantAnalyzer)
    case variableAnalyzer(_VariableAnalyzer)
}

extension _PropertyAnalyzer {
    
    @inlinable
    internal init(for syntacticDeclaration: SyntacticDeclaration, in protocolAnalyzer: _ProtocolAnalyzer) {}
    
    @inlinable
    internal init(for syntacticDeclaration: SyntacticDeclaration, in structureAnalyzer: _StructureAnalyzer) {}
}
