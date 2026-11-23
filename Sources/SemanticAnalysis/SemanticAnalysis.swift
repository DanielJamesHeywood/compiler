import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public convenience init(analyzing syntacticModules: [SyntacticModule]) throws(SemanticAnalysisError) {
        self.init()
    }
}
