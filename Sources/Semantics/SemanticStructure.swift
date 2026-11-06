import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal let _container: SemanticContainer
    
    @usableFromInline
    internal var _constants = [] as [SemanticConstant]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _variables = [] as [SemanticVariable]
    
    @usableFromInline
    internal var _unlabelledNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _initializerLabels = [] as Set<[Identifier]>
    
    @usableFromInline
    internal var _structureNames = [] as Set<Identifier>
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        in module: SemanticModule,
        at location: SourceLocation?
    ) {
        precondition(
            !module._unlabelledNames.contains(_name),
            "The module cannot contain another declaration named \"\(_name)\""
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.location = location
        self._container = .module(Weak(module))
    }
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        in structure: SemanticStructure,
        at location: SourceLocation?
    ) {
        precondition(
            !structure._structureNames.contains(_name),
            "The structure \"\(structure.name)\" cannot contain another structure named \"\(_name)\""
        )
        precondition(
            accessLevel == .private || structure.accessLevel == .public,
            "The private structure \"\(structure.name)\" cannot contain a public structure"
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.location = location
        self._container = .structure(Weak(structure))
    }
    
    @inlinable
    public var constants: [SemanticConstant] { _constants }
    
    @inlinable
    public var functions: [SemanticFunction] { _functions }
    
    @inlinable
    public var initializers: [SemanticInitializer] { _initializers }
    
    @inlinable
    public var structures: [SemanticStructure] { _structures }
    
    @inlinable
    public var variables: [SemanticVariable] { _variables }
    
    @inlinable
    public func appendConstant(
        _ name: Identifier,
        accessLevel: AccessLevel,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticConstant {
        let constant = SemanticConstant(
            _name: name,
            accessLevel: accessLevel,
            type: type,
            in: self,
            at: location
        )
        _constants.append(constant)
        _unlabelledNames.insert(name)
        return constant
    }
    
    @inlinable
    public func appendFunction(
        _ name: Identifier,
        accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) -> SemanticFunction {
        let function = SemanticFunction(
            _name: name,
            accessLevel: accessLevel,
            parameters: parameters,
            returnType: returnType,
            in: self,
            at: location
        )
        _functions.append(function)
        if parameters.allSatisfy({ $0.label ?? $0.name == "_" }) {
            _unlabelledNames.insert(name)
        }
        return function
    }
    
    @inlinable
    public func appendInitializer(
        accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        at location: SourceLocation?
    ) -> SemanticInitializer {
        let initializer = SemanticInitializer(
            _accessLevel: accessLevel,
            parameters: parameters,
            in: self,
            at: location
        )
        _initializers.append(initializer)
        let labels = parameters.map { $0.label ?? $0.name }
        _initializerLabels.insert(labels)
        return initializer
    }
    
    @inlinable
    public func appendStructure(
        _ name: Identifier,
        accessLevel: AccessLevel,
        at location: SourceLocation?
    ) -> SemanticStructure {
        let structure = SemanticStructure(
            _name: name,
            accessLevel: accessLevel,
            in: self,
            at: location
        )
        _structures.append(structure)
        _structureNames.insert(name)
        return structure
    }
    
    @inlinable
    public func appendVariable(
        _ name: Identifier,
        accessLevel: AccessLevel,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticVariable {
        let variable = SemanticVariable(
            _name: name,
            accessLevel: accessLevel,
            type: type,
            in: self,
            at: location
        )
        _variables.append(variable)
        _unlabelledNames.insert(name)
        return variable
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
