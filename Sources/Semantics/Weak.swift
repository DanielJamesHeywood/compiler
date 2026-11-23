public struct Weak<Object: AnyObject> {
    
    public weak let object: Object?
    
    @inlinable
    public init(_ object: Object) {
        self.object = object
    }
}

extension Weak: Equatable where Object: Equatable {
    
    @inlinable
    public static func == (lhs: Weak, rhs: Weak) -> Bool {
        guard let lhObject = lhs.object else {
            preconditionFailure("The left hand object has been deallocated")
        }
        guard let rhObject = rhs.object else {
            preconditionFailure("The right hand object has been deallocated")
        }
        return lhObject == rhObject
    }
}

extension Weak: Hashable where Object: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        guard let object else {
            preconditionFailure("The object has been deallocated")
        }
        hasher.combine(object)
    }
}

extension Weak: Sendable where Object: Sendable {}
