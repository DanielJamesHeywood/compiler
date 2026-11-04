public struct SemanticModule: Hashable {
    
    public let constants: [SemanticConstant]
    
    public let functions: [SemanticFunction]
    
    public let structures: [SemanticStructure]
    
    public let variables: [SemanticVariable]
    
    @inlinable
    public init(
        constants: [SemanticConstant],
        functions: [SemanticFunction],
        structures: [SemanticStructure],
        variables: [SemanticVariable]
    ) {
        self.constants = constants
        self.functions = functions
        self.structures = structures
        self.variables = variables
    }
}
