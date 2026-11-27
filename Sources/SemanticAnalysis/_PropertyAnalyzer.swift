import Syntax

@usableFromInline
internal enum _PropertyAnalyzer {
    case constantAnalyzer(_ConstantAnalyzer)
    case variableAnalyzer(_VariableAnalyzer)
}

extension _PropertyAnalyzer {
    
    @inlinable
    internal init(
        for syntacticDeclaration: SyntacticDeclaration,
        in container: _Container
    ) throws(SemanticAnalysisError) {
        self = switch syntacticDeclaration.kind {
        case .constant:
            .constantAnalyzer(try _ConstantAnalyzer(for: syntacticDeclaration, in: container))
        case .variable:
            .variableAnalyzer(try _VariableAnalyzer(for: syntacticDeclaration, in: container))
        default:
            preconditionFailure("The declaration is not a property")
        }
    }
    
    @inlinable
    internal init(
        for syntacticDeclaration: SyntacticDeclaration,
        in protocolAnalyzer: _ProtocolAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticDeclaration, in: _Container(protocolAnalyzer))
    }
    
    @inlinable
    internal init(
        for syntacticDeclaration: SyntacticDeclaration,
        in structureAnalyzer: _StructureAnalyzer
    ) throws(SemanticAnalysisError) {
        try self.init(for: syntacticDeclaration, in: _Container(structureAnalyzer))
    }
}
