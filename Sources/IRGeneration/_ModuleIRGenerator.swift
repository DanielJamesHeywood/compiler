import LLVM

import Tokens
import Syntax
import Semantics

@usableFromInline
internal final class _ModuleIRGenerator {
    
    @usableFromInline
    internal var _llvmModule: LLVMModule?
    
    @usableFromInline
    internal var _llvmTypesForStructures = [:] as [SemanticStructure: LLVMType]
    
    @usableFromInline
    internal var _indicesForProperties = [:] as [SemanticProperty: Int]
    
    @usableFromInline
    internal var _llvmGlobalVariablesForConstants = [:] as [SemanticConstant: LLVMGlobalVariable]
    
    @usableFromInline
    internal var _llvmGlobalVariablesForVariables = [:] as [SemanticVariable: LLVMGlobalVariable]
    
    @usableFromInline
    internal var _llvmFunctionsForInitializers = [:] as [SemanticInitializer: LLVMFunction]
    
    @usableFromInline
    internal var _llvmFunctionsForFunctions = [:] as [SemanticFunction: LLVMFunction]
    
    @usableFromInline
    internal var _externalNames = [] as Set<Identifier>
    
    @inlinable
    internal init(in llvmContext: LLVMContext) {
        self._llvmModule = LLVMModule(in: llvmContext)
    }
    
    @inlinable
    internal func defineLLVMGlobalVariable(for constant: SemanticConstant) {
        guard let llvmModule = _llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        precondition(constant.isExternal, "The constant \"\(constant.name)\" is not external")
        precondition(constant.containingModule != nil, "The constant \"\(constant.name)\" is not declared in a module")
        _insertExternalName(constant.name)
        _llvmGlobalVariablesForConstants[constant] = llvmModule.addGlobal(
            constant.name.text,
            type: _llvmType(for: constant.type)
        )
    }
    
    @inlinable
    internal func defineLLVMGlobalVariable(for variable: SemanticVariable) {
        guard let llvmModule = _llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        precondition(variable.isExternal, "The variable \"\(variable.name)\" is not external")
        precondition(variable.containingModule != nil, "The variable \"\(variable.name)\" is not declared in a module")
        _insertExternalName(variable.name)
        _llvmGlobalVariablesForVariables[variable] = llvmModule.addGlobal(
            variable.name.text,
            type: _llvmType(for: variable.type)
        )
    }
    
    @inlinable
    internal func defineLLVMFunction(for initializer: SemanticInitializer) {
        _FunctionIRGenerator(for: initializer, in: self).defineLLVMFunction()
    }
    
    @inlinable
    internal func defineLLVMFunction(for function: SemanticFunction) {
        _FunctionIRGenerator(for: function, in: self).defineLLVMFunction()
    }
    
    @inlinable
    internal func takeLLVMModule() -> LLVMModule {
        guard let llvmModule = _llvmModule.take() else {
            preconditionFailure("The LLVM module has already been taken")
        }
        _llvmGlobalVariablesForConstants.removeAll()
        _llvmGlobalVariablesForVariables.removeAll()
        _llvmFunctionsForInitializers.removeAll()
        _llvmFunctionsForFunctions.removeAll()
        _externalNames.removeAll()
        return llvmModule
    }
    
    @inlinable
    internal func _llvmType(for type: SemanticType) -> LLVMType {
        guard let llvmModule = _llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        var structuresBeingLowered = [] as Set<SemanticStructure>
        func llvmType(for type: SemanticType) -> LLVMType {
            switch type.kind {
            case let .structure(weakStructure):
                guard let structure = weakStructure.object else {
                    preconditionFailure("The structure has been deallocated")
                }
                if let llvmType = _llvmTypesForStructures[structure] {
                    return llvmType
                } else {
                    precondition(
                        !structuresBeingLowered.contains(structure),
                        "The structure \"\(structure.name)\" recursively contains itself"
                    )
                    structuresBeingLowered.insert(structure)
                    let llvmType = LLVMStructureType(
                        elementTypes: structure.properties.map { llvmType(for: $0.type) },
                        in: llvmModule.context
                    )
                    structuresBeingLowered.remove(structure)
                    _llvmTypesForStructures[structure] = llvmType
                    return llvmType
                }
            case let .integerPrimitive(bitWidth: bitWidth):
                return LLVMIntegerType(bitWidth: bitWidth.value, in: llvmModule.context)
            case let .bytePrimitive(bitWidth: bitWidth):
                return LLVMByteType(bitWidth: bitWidth.value, in: llvmModule.context)
            }
        }
        return llvmType(for: type)
    }
    
    @inlinable
    internal func _llvmFunctionType(for function: SemanticFunction) -> LLVMFunctionType {
        var llvmParameterTypes = function.containingStructure.map { [_llvmType(for: .structure($0))] } ?? []
        llvmParameterTypes += function.parameters.map { _llvmType(for: $0.type) }
        return LLVMFunctionType(returnType: _llvmType(for: function.returnType), parameterTypes: llvmParameterTypes)
    }
    
    @inlinable
    internal func _llvmFunctionType(for initializer: SemanticInitializer) -> LLVMFunctionType {
        guard let structure = initializer.containingStructure else {
            preconditionFailure("The initializer is not a member of a structure")
        }
        return LLVMFunctionType(
            returnType: _llvmType(for: .structure(structure)),
            parameterTypes: initializer.parameters.map { _llvmType(for: $0.type) }
        )
    }
    
    @inlinable
    internal func _index(for property: SemanticProperty) -> Int {
        if let index = _indicesForProperties[property] {
            return index
        } else {
            guard let structure = property.containingStructure else {
                preconditionFailure("The property \"\(property.name)\" is not a member of a structure")
            }
            for (index, property) in structure.properties.enumerated() {
                _indicesForProperties[property] = index
            }
            return _indicesForProperties[property].unsafelyUnwrapped
        }
    }
    
    @inlinable
    internal func _llvmFunction(for initializer: SemanticInitializer) -> LLVMFunction {
        if let llvmFunction = _llvmFunctionsForInitializers[initializer] {
            return llvmFunction
        } else {
            defineLLVMFunction(for: initializer)
            return _llvmFunctionsForInitializers[initializer].unsafelyUnwrapped
        }
    }
    
    @inlinable
    internal func _insertExternalName(_ name: Identifier) {
        precondition(_llvmModule != nil, "The LLVM module has been taken")
        precondition(!_externalNames.contains(name), "The external declaration \"\(name)\" is not uniquely named")
        _externalNames.insert(name)
    }
}
