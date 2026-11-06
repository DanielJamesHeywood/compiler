public struct Weak<Object: AnyObject> {
    
    public weak let object: Object!
    
    @inlinable
    public init(_ object: Object) {
        self.object = object
    }
}

extension Weak: Equatable where Object: Equatable {}

extension Weak: Hashable where Object: Hashable {}

extension Weak: Sendable where Object: Sendable {}
