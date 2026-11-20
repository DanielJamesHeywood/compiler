public struct SyntacticModule: Hashable, Sendable {
    
    public let declarations: [SyntacticDeclaration]
    
    @inlinable
    public init(declarations: [SyntacticDeclaration]) {
        self.declarations = declarations
    }
    
    @inlinable
    public init(@ArrayBuilder<SyntacticDeclaration> makeDeclarations: () -> [SyntacticDeclaration]) {
        self.init(declarations: makeDeclarations())
    }
}
