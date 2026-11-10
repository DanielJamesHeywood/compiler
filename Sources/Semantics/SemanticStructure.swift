import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @usableFromInline
    internal var _properties = [] as [SemanticProperty]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(_ name: Identifier, accessLevel: AccessLevel, at location: SourceLocation?) {
        self.name = name
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public var functions: [SemanticFunction] {
        get { _functions }
        set {
            for function in _functions {
                function._container = nil
            }
            for function in newValue {
                precondition(function._container == nil, "A function is already declared in a module or structure")
                function._container = _Container(self)
            }
            _functions = newValue
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
                precondition(initializer._container == nil, "An initializer is already declared in a structure")
                initializer._container = _Container(self)
            }
            _initializers = newValue
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
                precondition(property._container == nil, "A property is already declared in a module or structure")
                property._container = _Container(self)
            }
            _properties = newValue
        }
    }
    
    @inlinable
    public var structures: [SemanticStructure] {
        get { _structures }
        set {
            for structure in _structures {
                structure._container = nil
            }
            for structure in newValue {
                precondition(structure._container == nil, "A structure is already declared in a module or structure")
                structure._container = _Container(self)
            }
            _structures = newValue
        }
    }
}

extension SemanticStructure: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticStructure, rhs: SemanticStructure) -> Bool { lhs === rhs }
}

extension SemanticStructure: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticStructure: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: [
                "name": name,
                "accessLevel": accessLevel,
                "location": location as Any,
                "functions": functions,
                "initializers": initializers,
                "properties": properties,
                "structures": structures
            ],
            displayStyle: .class
        )
    }
}
