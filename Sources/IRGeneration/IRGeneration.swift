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
                type: constant.type.llvmType(in: llvmContext),
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
                type: variable.type.llvmType(in: llvmContext),
                linkage: .external
            )
        }
        for function in functions {
            _ = llvmModule.addFunction(
                function.isExternal ? function.name.text : "",
                type: LLVMFunctionType(
                    returnType: function.returnType.llvmType(in: llvmContext),
                    parameterTypes: function.parameters.map { $0.type.llvmType(in: llvmContext) }
                ),
                linkage: function.isExternal ? .external : .private
            )
        }
        return llvmModule
    }
}

extension SemanticType {
    
    @inlinable
    public func llvmType(in llvmContext: LLVMContext) -> LLVMType {
        switch kind {
        case let .structure(weakStructure):
            guard let structure = weakStructure.object else {
                preconditionFailure("The structure has been deallocated")
            }
            let propertyTypes = structure.constants.map(\.type) + structure.variables.map(\.type)
            return LLVMStructureType(elementTypes: propertyTypes.map { $0.llvmType(in: llvmContext) }, in: llvmContext)
        case let .integerPrimitive(bitWidth: bitWidth):
            return LLVMIntegerType(bitWidth: bitWidth.value, in: llvmContext)
        case let .bytePrimitive(bitWidth: bitWidth):
            return LLVMByteType(bitWidth: bitWidth.value, in: llvmContext)
        }
    }
}
