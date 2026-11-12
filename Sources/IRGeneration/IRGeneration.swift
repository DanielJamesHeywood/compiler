import LLVM

import Tokens
import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public func makeLLVMModule(in llvmContext: LLVMContext) -> LLVMModule {
        var generator = _IRGenerator(in: llvmContext)
        for constant in constants {
            generator.declareGlobalVariable(for: constant)
        }
        for variable in variables {
            generator.declareGlobalVariable(for: variable)
        }
        return generator.takeLLVMModule()
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
