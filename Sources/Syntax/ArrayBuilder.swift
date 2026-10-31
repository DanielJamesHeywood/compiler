@resultBuilder
public enum ArrayBuilder<Element> {
    
    @inlinable
    public static func buildBlock(_ components: [Element]...) -> [Element] { components.flatMap(\.self) }
    
    @inlinable
    public static func buildOptional(_ component: [Element]?) -> [Element] { component ?? [] }
    
    @inlinable
    public static func buildEither(first: [Element]) -> [Element] { first }
    
    @inlinable
    public static func buildEither(second: [Element]) -> [Element] { second }
    
    @inlinable
    public static func buildArray(_ components: [[Element]]) -> [Element] { components.flatMap(\.self) }
    
    @inlinable
    public static func buildExpression(_ expression: Element) -> [Element] { [expression] }
}
