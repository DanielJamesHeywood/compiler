import LLVM

import Semantics
import Syntax
import Tokens

extension SemanticModule {
    
    @inlinable
    public func makeLLVMModule(in llvmContext: LLVMContext) -> LLVMModule {
        let llvmModule = LLVMModule(in: llvmContext)
        var llvmGlobalVariablesForConstants = [:] as [SemanticConstant: LLVMGlobalVariable]
        for constant in constants {
            precondition(
                constant.isExternal,
                "Expected each constant in the module to be external, but \"\(constant.name)\" is not"
            )
            llvmGlobalVariablesForConstants[constant] = llvmModule.addGlobal(
                constant.name.text,
                type: constant.type._llvmType(in: llvmContext),
                linkage: .external
            )
        }
        var llvmGlobalVariablesForVariables = [:] as [SemanticVariable: LLVMGlobalVariable]
        for variable in variables {
            precondition(
                variable.isExternal,
                "Expected each variable in the module to be external, but \"\(variable.name)\" is not"
            )
            llvmGlobalVariablesForVariables[variable] = llvmModule.addGlobal(
                variable.name.text,
                type: variable.type._llvmType(in: llvmContext),
                linkage: .external
            )
        }
        let externalNames = constants.map(\.name) + variables.map(\.name) + functions.filter(\.isExternal).map(\.name)
        precondition(Set(externalNames).count == externalNames.count, "The external names in the module are not unique")
        for function in functions {
            let llvmFunction = llvmModule.addFunction(
                function.isExternal ? function.name.text : "",
                type: LLVMFunctionType(
                    returnType: function.returnType._llvmType(in: llvmContext),
                    parameterTypes: function.parameters.map { $0.type._llvmType(in: llvmContext) }
                ),
                linkage: function.isExternal ? .external : .private
            )
            if let body = function.body {
                _ = llvmFunction.appendBasicBlock()
                _ = body
            } else {
                precondition(function.isExternal, "The function \"\(function.name)\" has no body but is not external")
            }
        }
        return llvmModule
    }
}

extension SemanticType {
    
    @inlinable
    internal func _llvmType(in llvmContext: LLVMContext) -> LLVMType {
        var structuresBeingLowered = [] as Set<SemanticStructure>
        func llvmType(for type: SemanticType) -> LLVMType {
            switch type.kind {
            case let .structure(weakStructure):
                guard let structure = weakStructure.object else {
                    preconditionFailure("The structure has been deallocated")
                }
                precondition(
                    !structuresBeingLowered.contains(structure),
                    "The structure \"\(structure.name)\" recursively contains itself"
                )
                structuresBeingLowered.insert(structure)
                defer {
                    structuresBeingLowered.remove(structure)
                }
                return LLVMStructureType(
                    elementTypes: structure.properties.map { llvmType(for: $0.type) },
                    in: llvmContext
                )
            case let .integerPrimitive(bitWidth: bitWidth):
                return LLVMIntegerType(bitWidth: bitWidth.value, in: llvmContext)
            case let .bytePrimitive(bitWidth: bitWidth):
                return LLVMByteType(bitWidth: bitWidth.value, in: llvmContext)
            }
        }
        return llvmType(for: self)
    }
}
