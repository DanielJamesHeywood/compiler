import LLVM

import Semantics
import Syntax

extension SemanticType {
    
    @inlinable
    public func llvmType(in context: LLVMContext) -> LLVMType {
        switch kind {
        case let .structure(weakStructure):
            guard let structure = weakStructure.object else {
                preconditionFailure("The structure has been deallocated")
            }
            let propertyTypes = structure.constants.map(\.type) + structure.variables.map(\.type)
            return LLVMStructureType(elementTypes: propertyTypes.map { $0.llvmType(in: context) }, in: context)
        case let .integerPrimitive(bitWidth: bitWidth):
            return LLVMIntegerType(bitWidth: bitWidth.value, in: context)
        case let .bytePrimitive(bitWidth: bitWidth):
            return LLVMByteType(bitWidth: bitWidth.value, in: context)
        }
    }
}
