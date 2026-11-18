import LLVM

import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _FunctionIRGenerator {
    
    @usableFromInline
    internal enum _Kind {
        case initializer(SemanticInitializer)
        case function(SemanticFunction)
    }
    
    @usableFromInline
    internal let _kind: _Kind
    
    @usableFromInline
    internal let _moduleIRGenerator: _ModuleIRGenerator
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @usableFromInline
    internal var _llvmValueForSelf: LLVMValue?
    
    @usableFromInline
    internal var _llvmArgumentsForParameters = [:] as [SemanticParameter: LLVMArgument]
    
    @inlinable
    internal init(_kind: _Kind, in moduleIRGenerator: _ModuleIRGenerator) {
        guard let llvmModule = moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        self._kind = _kind
        self._moduleIRGenerator = moduleIRGenerator
        self._llvmBuilder = LLVMBuilder(in: llvmModule.context)
    }
    
    @inlinable
    internal convenience init(for initializer: SemanticInitializer, in moduleIRGenerator: _ModuleIRGenerator) {
        self.init(_kind: .initializer(initializer), in: moduleIRGenerator)
    }
    
    @inlinable
    internal convenience init(for function: SemanticFunction, in moduleIRGenerator: _ModuleIRGenerator) {
        self.init(_kind: .function(function), in: moduleIRGenerator)
    }
    
    @inlinable
    internal func defineLLVMFunction() {
        guard let llvmModule = _moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        switch _kind {
        case let .initializer(initializer):
            precondition(
                _moduleIRGenerator._llvmFunctionsForInitializers[initializer] == nil,
                "The initializer is already defined"
            )
            let llvmFunction = llvmModule.addFunction(
                type: _moduleIRGenerator._llvmFunctionType(for: initializer),
                linkage: .internal
            )
            _moduleIRGenerator._llvmFunctionsForInitializers[initializer] = llvmFunction
            guard let body = initializer.body else {
                preconditionFailure("The initializer has no body")
            }
            guard let structure = initializer.containingStructure else {
                preconditionFailure("The initializer is not a member of a structure")
            }
            _llvmValueForSelf = LLVMPoisonValue(type: _moduleIRGenerator._llvmStructureType(for: structure))
            for (index, parameter) in initializer.parameters.enumerated() {
                _llvmArgumentsForParameters[parameter] = llvmFunction.argument(
                    at: index
                )
            }
        case let .function(function):
            if function.isExternal {
                _moduleIRGenerator._insertExternalName(function.name)
            } else {
                precondition(
                    _moduleIRGenerator._llvmFunctionsForFunctions[function] == nil,
                    "The function \"\(function.name)\" is already defined"
                )
            }
            let llvmFunction = llvmModule.addFunction(
                function.isExternal ? function.name.text : "",
                type: _moduleIRGenerator._llvmFunctionType(for: function),
                linkage: function.isExternal ? .external : .internal
            )
            _moduleIRGenerator._llvmFunctionsForFunctions[function] = llvmFunction
            if let body = function.body {
                if function.containingStructure != nil {
                    _llvmValueForSelf = llvmFunction.argument(at: 0)
                }
                for (index, parameter) in function.parameters.enumerated() {
                    _llvmArgumentsForParameters[parameter] = llvmFunction.argument(
                        at: function.containingStructure != nil ? index + 1 : index
                    )
                }
            } else {
                precondition(function.isExternal, "The function \"\(function.name)\" has no body but is not external")
            }
        }
    }
    
    @inlinable
    internal func _llvmValue(for expression: SemanticExpression) -> LLVMValue {
        switch expression.kind {
        case let .constant(constant):
            return _llvmBuilder.buildLoad(
                of: _moduleIRGenerator._llvmType(for: constant.type),
                fromPointer: _moduleIRGenerator._llvmGlobalVariable(for: constant)
            )
        case let .variable(variable):
            return _llvmBuilder.buildLoad(
                of: _moduleIRGenerator._llvmType(for: variable.type),
                fromPointer: _moduleIRGenerator._llvmGlobalVariable(for: variable)
            )
        case let .parameter(parameter):
            guard let llvmArgument = _llvmArgumentsForParameters[parameter] else {
                preconditionFailure("The parameter \"\(parameter.name)\" is not declared by the function or initializer")
            }
            return llvmArgument
        case .self:
            guard let llvmValue = _llvmValueForSelf else {
                preconditionFailure("Self is not declared by the function or initializer")
            }
            return llvmValue
        case let .call(toInitializer: weakInitializer, passing: arguments):
            guard let initializer = weakInitializer.object else {
                preconditionFailure("The initializer has been deallocated")
            }
            precondition(
                arguments.elementsEqual(initializer.parameters, by: { _type(of: $0).kind == $1.type.kind }),
                "The types of the arguments do not match the types of the parameters"
            )
            return _llvmBuilder.buildCall(
                to: _moduleIRGenerator._llvmFunction(for: initializer),
                ofType: _moduleIRGenerator._llvmFunctionType(for: initializer),
                passing: arguments.map { _llvmValue(for: $0) }
            )
        case let .property(property, of: base):
            guard let structure = property.containingStructure else {
                preconditionFailure("The property \"\(property.name)\" is not a member of a structure")
            }
            precondition(
                _type(of: base).kind == .structure(Weak(structure)),
                "The property \"\(property.name)\" is not a member of the type of the base"
            )
            return _llvmBuilder.buildExtraction(
                fromAggregate: _llvmValue(for: base),
                at: _moduleIRGenerator._index(for: property)
            )
        case let .structurePrimitive(weakStructure, propertyValues: propertyValues):
            guard let structure = weakStructure.object else {
                preconditionFailure("The structure has been deallocated")
            }
            precondition(
                propertyValues.elementsEqual(structure.properties, by: { _type(of: $0).kind == $1.type.kind }),
                "The types of the property values do not match the types of the properties"
            )
            return LLVMConstant(
                elements: propertyValues.map { propertyValue in
                    guard let llvmConstant = _llvmValue(for: propertyValue) as? LLVMConstant else {
                        preconditionFailure("A property value is not constant")
                    }
                    return llvmConstant
                },
                type: _moduleIRGenerator._llvmStructureType(for: structure)
            )
        case let .integerPrimitive(words: words, bitWidth: bitWidth):
            return LLVMConstantInteger(
                words: words,
                type: LLVMIntegerType(bitWidth: bitWidth.value, in: _llvmBuilder.context)
            )
        case let .bytePrimitive(words: words, bitWidth: bitWidth):
            return LLVMConstantByte(
                words: words,
                type: LLVMByteType(bitWidth: bitWidth.value, in: _llvmBuilder.context)
            )
        case let .primitiveTruncation(of: value, to: type):
            guard case let .integerPrimitive(bitWidth: valueBitWidth) = _type(of: value).kind else {
                preconditionFailure("The value is not an integer primitive")
            }
            guard case let .integerPrimitive(bitWidth: typeBitWidth) = type.kind else {
                preconditionFailure("The type is not an integer primitive")
            }
            precondition(
                typeBitWidth < valueBitWidth,
                "Expected the type to be narrower than \(valueBitWidth) bits, but it is \(typeBitWidth) bits wide"
            )
            return _llvmBuilder.buildTruncation(
                of: _llvmValue(for: value),
                to: _moduleIRGenerator._llvmType(for: type)
            )
        case let .primitiveBitCast(of: value, to: type):
            let valueBitWidth = switch _type(of: value).kind {
            case let .integerPrimitive(bitWidth: bitWidth), let .bytePrimitive(bitWidth: bitWidth):
                bitWidth
            default:
                preconditionFailure("The value is not an integer or byte primitive")
            }
            let typeBitWidth = switch type.kind {
            case let .integerPrimitive(bitWidth: bitWidth), let .bytePrimitive(bitWidth: bitWidth):
                bitWidth
            default:
                preconditionFailure("The type is not an integer or byte primitive")
            }
            precondition(
                typeBitWidth == valueBitWidth,
                "Expected the type to be \(valueBitWidth) bits wide, but it is \(typeBitWidth) bits wide"
            )
            return _llvmBuilder.buildBitCast(
                of: _llvmValue(for: value),
                to: _moduleIRGenerator._llvmType(for: type)
            )
        }
    }
    
    @inlinable
    internal func _type(of expression: SemanticExpression) -> SemanticType {
        switch expression.kind {
        case let .constant(constant):
            return constant.type
        case let .variable(variable):
            return variable.type
        case let .parameter(parameter):
            return parameter.type
        case .self:
            let structure = switch _kind {
            case let .function(function):
                function.containingStructure
            case let .initializer(initializer):
                initializer.containingStructure
            }
            guard let structure else {
                preconditionFailure("Self is not declared by the function or initializer")
            }
            return .structure(structure)
        case let .call(toInitializer: weakInitializer, passing: _):
            guard let initializer = weakInitializer.object else {
                preconditionFailure("The initializer has been deallocated")
            }
            guard let structure = initializer.containingStructure else {
                preconditionFailure("The initializer is not a member of a structure")
            }
            return .structure(structure)
        case let .property(property, of: _):
            return property.type
        case let .structurePrimitive(weakStructure, propertyValues: _):
            guard let structure = weakStructure.object else {
                preconditionFailure("The structure has been deallocated")
            }
            return .structure(structure)
        case let .integerPrimitive(words: _, bitWidth: bitWidth):
            return .integerPrimitive(bitWidth: bitWidth)
        case let .bytePrimitive(words: _, bitWidth: bitWidth):
            return .bytePrimitive(bitWidth: bitWidth)
        case let .primitiveTruncation(of: _, to: type):
            return type
        case let .primitiveBitCast(of: _, to: type):
            return type
        }
    }
}
