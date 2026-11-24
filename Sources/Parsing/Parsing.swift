import Tokens
import Syntax

extension SyntacticModule {
    
    @inlinable
    public init(parsing tokenizedSourceFile: TokenizedSourceFile) throws(ParsingError) {
        let parser = _Parser(for: tokenizedSourceFile)
        self = try parser._parseModule()
    }
}
