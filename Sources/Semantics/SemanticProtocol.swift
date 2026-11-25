import Tokens
import Syntax

public final class SemanticProtocol {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal let _conformances: [Weak<SemanticProtocol>]
    
    @usableFromInline
    internal var _properties = [] as [SemanticProperty]
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(
        _ name: Identifier,
        accessLevel: AccessLevel,
        conformances: [SemanticProtocol],
        at location: SourceLocation?
    ) {
        self.name = name
        self.accessLevel = accessLevel
        self._conformances = conformances.map { conformance in Weak(conformance) }
        self.location = location
    }
    
    @inlinable
    public var conformances: [SemanticProtocol] {
        _conformances.map { weakConformance in
            guard let conformance = weakConformance.object else {
                preconditionFailure("The protocol has been deallocated")
            }
            return conformance
        }
    }
    
    @inlinable
    public var properties: [SemanticProperty] {
        get { _properties }
        set {
            for property in _properties {
                property._container = nil
            }
            for property in newValue {
                precondition(
                    property._container == nil,
                    "A property is already declared in a module, protocol or structure"
                )
                property._container = _Container(self)
            }
            _properties = newValue
        }
    }
    
    @inlinable
    public var initializers: [SemanticInitializer] {
        get { _initializers }
        set {
            for initializer in _initializers {
                initializer._container = nil
            }
            for initializer in newValue {
                precondition(
                    initializer._container == nil,
                    "An initializer is already declared in a protocol or structure"
                )
                initializer._container = _Container(self)
            }
            _initializers = newValue
        }
    }
    
    @inlinable
    public var functions: [SemanticFunction] {
        get { _functions }
        set {
            for function in _functions {
                function._container = nil
            }
            for function in newValue {
                precondition(
                    function._container == nil,
                    "A function is already declared in a module, protocol or structure"
                )
                function._container = _Container(self)
            }
            _functions = newValue
        }
    }
}

extension SemanticProtocol: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticProtocol, rhs: SemanticProtocol) -> Bool { lhs === rhs }
}

extension SemanticProtocol: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticProtocol: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: [
                "name": name,
                "accessLevel": accessLevel,
                "location": location as Any,
                "conformances": conformances,
                "properties": properties,
                "initializers": initializers,
                "functions": functions
            ],
            displayStyle: .class
        )
    }
}
