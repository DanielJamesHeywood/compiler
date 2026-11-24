import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public convenience init(analyzing syntacticModules: [SyntacticModule]) throws(SemanticAnalysisError) {
        let analyzer = _Analyzer()
        self.init()
        self.structures = analyzer.takeSemanticStructures()
        self.constants = analyzer.takeSemanticConstants()
        self.variables = analyzer.takeSemanticVariables()
        self.functions = analyzer.takeSemanticFunctions()
    }
}
