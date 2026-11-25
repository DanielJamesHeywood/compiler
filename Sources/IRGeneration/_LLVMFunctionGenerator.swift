import LLVM

import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _LLVMFunctionGenerator {
    
    @usableFromInline
    internal enum _Kind {
        case initializer(SemanticInitializer)
        case function(SemanticFunction)
    }
    
    @usableFromInline
    internal let _kind: _Kind
    
    @usableFromInline
    internal let _moduleGenerator: _LLVMModuleGenerator
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @usableFromInline
    internal var _llvmValueForSelf: LLVMValue?
    
    @usableFromInline
    internal var _llvmArgumentsForParameters = [:] as [SemanticParameter: LLVMArgument]
    
    @usableFromInline
    internal var _currentBlockIsTerminated = false
    
    @inlinable
    internal init(_kind: _Kind, in moduleGenerator: _LLVMModuleGenerator) {
        guard let llvmModule = moduleGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        self._kind = _kind
        self._moduleGenerator = moduleGenerator
        self._llvmBuilder = LLVMBuilder(in: llvmModule.context)
    }
    
    @inlinable
    internal convenience init(for initializer: SemanticInitializer, in moduleGenerator: _LLVMModuleGenerator) {
        self.init(_kind: .initializer(initializer), in: moduleGenerator)
    }
    
    @inlinable
    internal convenience init(for function: SemanticFunction, in moduleGenerator: _LLVMModuleGenerator) {
        self.init(_kind: .function(function), in: moduleGenerator)
    }
    
    @inlinable
    internal func defineLLVMFunction() {
        guard let llvmModule = _moduleGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        switch _kind {
        case let .initializer(initializer):
            precondition(
                _moduleGenerator._llvmFunctionsForInitializers[initializer] == nil,
                "The initializer is already defined"
            )
            let llvmFunction = llvmModule.addFunction(
                type: _moduleGenerator._llvmFunctionType(for: initializer),
                linkage: .internal
            )
            _moduleGenerator._llvmFunctionsForInitializers[initializer] = llvmFunction
            guard let body = initializer.body else {
                preconditionFailure("The initializer has no body")
            }
            guard let structure = initializer.containingStructure else {
                preconditionFailure("The initializer is not a member of a structure")
            }
            _llvmValueForSelf = LLVMPoisonValue(type: _moduleGenerator._llvmStructureType(for: structure))
            for (index, parameter) in initializer.parameters.enumerated() {
                _llvmArgumentsForParameters[parameter] = llvmFunction.argument(at: index)
            }
            _llvmBuilder.position(atEndOf: llvmFunction.appendBasicBlock())
            for statement in body {
                _generateIR(for: statement)
            }
            _llvmBuilder.buildReturn(of: _llvmValueForSelf.unsafelyUnwrapped)
            _currentBlockIsTerminated = true
        case let .function(function):
            if function.isExternal {
                _moduleGenerator._insertExternalName(function.name)
                precondition(
                    function.containingStructure == nil,
                    "The external function \"\(function.name)\" is a member of a structure"
                )
            } else {
                precondition(
                    _moduleGenerator._llvmFunctionsForFunctions[function] == nil,
                    "The function \"\(function.name)\" is already defined"
                )
            }
            let llvmFunction = llvmModule.addFunction(
                function.isExternal ? function.name.text : "",
                type: _moduleGenerator._llvmFunctionType(for: function),
                linkage: function.isExternal ? .external : .internal
            )
            _moduleGenerator._llvmFunctionsForFunctions[function] = llvmFunction
            if let body = function.body {
                if function.containingStructure != nil {
                    _llvmValueForSelf = llvmFunction.argument(at: 0)
                }
                for (index, parameter) in zip(function.containingStructure != nil ? 1... : 0..., function.parameters) {
                    _llvmArgumentsForParameters[parameter] = llvmFunction.argument(at: index)
                }
                _llvmBuilder.position(atEndOf: llvmFunction.appendBasicBlock())
                for statement in body {
                    _generateIR(for: statement)
                }
                if !_currentBlockIsTerminated {
                    _llvmBuilder.buildReturn(
                        of: LLVMPoisonValue(type: _moduleGenerator._llvmType(for: function.returnType))
                    )
                    _currentBlockIsTerminated = true
                }
            } else {
                precondition(function.isExternal, "The function \"\(function.name)\" has no body but is not external")
            }
        }
    }
    
    @inlinable
    internal func _generateIR(for statement: SemanticStatement) {
        precondition(_moduleGenerator._llvmModule != nil, "The LLVM module has been taken")
        precondition(!_currentBlockIsTerminated, "The statement is unreachable")
        switch statement.kind {
        case let .return(of: value):
            let returnType = switch _kind {
            case let .function(function):
                function.returnType
            default:
                preconditionFailure("The declaration cannot contain a return statement")
            }
            if let value {
                precondition(_type(of: value) == returnType, "The type of the value does not match the return type")
                _llvmBuilder.buildReturn(of: _llvmValue(for: value))
            } else {
                preconditionFailure("The statement returns nothing")
            }
            _currentBlockIsTerminated = true
        case let .assignment(of: source, to: destination):
            precondition(
                _type(of: source) == _type(of: destination),
                "The types of the source and destination do not match"
            )
            var llvmAggregateValuesForExpressions = [:] as [SemanticExpression: LLVMValue]
            func llvmAggregateValue(for expression: SemanticExpression) -> LLVMValue {
                if let llvmValue = llvmAggregateValuesForExpressions[expression] {
                    return llvmValue
                } else {
                    let llvmValue: LLVMValue
                    switch expression.kind {
                    case .variable, .self:
                        llvmValue = _llvmValue(for: expression)
                    case let .property(property, of: base):
                        guard let structure = property.containingStructure else {
                            preconditionFailure("The property \"\(property.name)\" is not a member of a structure")
                        }
                        precondition(
                            _type(of: base) == .structure(structure),
                            "The property \"\(property.name)\" is not a member of the type of the base"
                        )
                        llvmValue = _llvmBuilder.buildExtraction(
                            fromAggregate: llvmAggregateValue(for: base),
                            at: _moduleGenerator._index(for: property)
                        )
                    default:
                        preconditionFailure("The expression is not assignable")
                    }
                    llvmAggregateValuesForExpressions[expression] = llvmValue
                    return llvmValue
                }
            }
            func buildAssignment(of llvmValue: LLVMValue, to destination: SemanticExpression) {
                switch destination.kind {
                case let .variable(variable):
                    _llvmBuilder.buildStore(of: llvmValue, toPointer: _moduleGenerator._llvmGlobalVariable(for: variable))
                case .self:
                    let selfIsAssignable = switch _kind {
                    case .initializer:
                        true
                    case .function:
                        false
                    }
                    precondition(selfIsAssignable, "Self is not assignable in the declaration")
                    _llvmValueForSelf = llvmValue
                case let .property(property, of: base):
                    guard let structure = property.containingStructure else {
                        preconditionFailure("The property \"\(property.name)\" is not a member of a structure")
                    }
                    precondition(
                        _type(of: base) == .structure(structure),
                        "The property \"\(property.name)\" is not a member of the type of the base"
                    )
                    buildAssignment(
                        of: _llvmBuilder.buildInsertion(
                            of: llvmValue,
                            intoAggregate: llvmAggregateValue(for: base),
                            at: _moduleGenerator._index(for: property)
                        ),
                        to: base
                    )
                default:
                    preconditionFailure("The destination is not assignable")
                }
            }
            buildAssignment(of: _llvmValue(for: source), to: destination)
        }
    }
    
    @inlinable
    internal func _llvmValue(for expression: SemanticExpression) -> LLVMValue {
        precondition(_moduleGenerator._llvmModule != nil, "The LLVM module has been taken")
        precondition(!_currentBlockIsTerminated, "The expression is unreachable")
        switch expression.kind {
        case let .constant(constant):
            return _llvmBuilder.buildLoad(
                of: _moduleGenerator._llvmType(for: constant.type),
                fromPointer: _moduleGenerator._llvmGlobalVariable(for: constant)
            )
        case let .variable(variable):
            return _llvmBuilder.buildLoad(
                of: _moduleGenerator._llvmType(for: variable.type),
                fromPointer: _moduleGenerator._llvmGlobalVariable(for: variable)
            )
        case let .parameter(parameter):
            guard let llvmArgument = _llvmArgumentsForParameters[parameter] else {
                preconditionFailure("The declaration has no parameter \"\(parameter.name)\"")
            }
            return llvmArgument
        case .self:
            guard let llvmValue = _llvmValueForSelf else {
                preconditionFailure("The declaration is not a member of a structure")
            }
            return llvmValue
        case let .call(toInitializer: weakInitializer, passing: arguments):
            guard let initializer = weakInitializer.object else {
                preconditionFailure("The initializer has been deallocated")
            }
            precondition(
                arguments.elementsEqual(
                    initializer.parameters,
                    by: { argument, parameter in _type(of: argument) == parameter.type }
                ),
                "The types of the arguments and parameters do not match"
            )
            return _llvmBuilder.buildCall(
                to: _moduleGenerator._llvmFunction(for: initializer),
                ofType: _moduleGenerator._llvmFunctionType(for: initializer),
                passing: arguments.map { argument in _llvmValue(for: argument) }
            )
        case let .property(property, of: base):
            guard let structure = property.containingStructure else {
                preconditionFailure("The property \"\(property.name)\" is not a member of a structure")
            }
            precondition(
                _type(of: base) == .structure(structure),
                "The property \"\(property.name)\" is not a member of the type of the base"
            )
            return _llvmBuilder.buildExtraction(
                fromAggregate: _llvmValue(for: base),
                at: _moduleGenerator._index(for: property)
            )
        case let .structurePrimitive(weakStructure, propertyValues: propertyValues):
            guard let structure = weakStructure.object else {
                preconditionFailure("The structure has been deallocated")
            }
            precondition(
                propertyValues.elementsEqual(
                    structure.properties,
                    by: { value, property in _type(of: value) == property.type }
                ),
                "The types of the property values and properties do not match"
            )
            return LLVMConstant(
                elements: propertyValues.map { value in
                    guard let llvmConstant = _llvmValue(for: value) as? LLVMConstant else {
                        preconditionFailure("A property value is not constant")
                    }
                    return llvmConstant
                },
                type: _moduleGenerator._llvmStructureType(for: structure)
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
            return _llvmBuilder.buildTruncation(of: _llvmValue(for: value), to: _moduleGenerator._llvmType(for: type))
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
            return _llvmBuilder.buildBitCast(of: _llvmValue(for: value), to: _moduleGenerator._llvmType(for: type))
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
                preconditionFailure("The declaration is not a member of a structure")
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
