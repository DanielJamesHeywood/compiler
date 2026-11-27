import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public convenience init(analyzing syntacticModules: [SyntacticModule]) throws(SemanticAnalysisError) {
        let analyzer = _Analyzer(for: syntacticModules)
        try analyzer.registerDeclarations()
        self.init()
        self.protocols = analyzer.takeSemanticProtocols()
        self.structures = analyzer.takeSemanticStructures()
        self.constants = analyzer.takeSemanticConstants()
        self.variables = analyzer.takeSemanticVariables()
        self.functions = analyzer.takeSemanticFunctions()
    }
}
