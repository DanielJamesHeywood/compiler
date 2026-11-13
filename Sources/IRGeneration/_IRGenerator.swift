import LLVM

import Tokens
import Syntax
import Semantics

@usableFromInline
internal struct _IRGenerator: ~Copyable {
    
    @usableFromInline
    internal let llvmContext: LLVMContext
    
    @usableFromInline
    internal let _llvmModule: LLVMModule
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @usableFromInline
    internal var _llvmTypesForStructures = [:] as [SemanticStructure: LLVMType]
    
    @usableFromInline
    internal var _llvmGlobalVariablesForConstants = [:] as [SemanticConstant: LLVMGlobalVariable]
    
    @usableFromInline
    internal var _llvmGlobalVariablesForVariables = [:] as [SemanticVariable: LLVMGlobalVariable]
    
    @usableFromInline
    internal var _externalNames = [] as Set<Identifier>
    
    @inlinable
    internal init(in llvmContext: LLVMContext) {
        self.llvmContext = llvmContext
        self._llvmModule = LLVMModule(in: llvmContext)
        self._llvmBuilder = LLVMBuilder(in: llvmContext)
    }
    
    @inlinable
    internal mutating func declareGlobalVariable(for constant: SemanticConstant) {
        precondition(constant.isExternal, "The constant \"\(constant.name)\" is not external")
        _insertExternalName(constant.name)
        _llvmGlobalVariablesForConstants[constant] = _llvmModule.addGlobal(
            constant.name.text,
            type: _llvmType(for: constant.type)
        )
    }
    
    @inlinable
    internal mutating func declareGlobalVariable(for variable: SemanticVariable) {
        precondition(variable.isExternal, "The variable \"\(variable.name)\" is not external")
        _insertExternalName(variable.name)
        _llvmGlobalVariablesForVariables[variable] = _llvmModule.addGlobal(
            variable.name.text,
            type: _llvmType(for: variable.type)
        )
    }
    
    @inlinable
    internal consuming func takeLLVMModule() -> LLVMModule { _llvmModule }
    
    @inlinable
    internal mutating func _llvmType(for type: SemanticType) -> LLVMType {
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
                        elementTypes: structure.properties.map { _llvmType(for: $0.type) },
                        in: llvmContext
                    )
                    structuresBeingLowered.remove(structure)
                    _llvmTypesForStructures[structure] = llvmType
                    return llvmType
                }
            case let .integerPrimitive(bitWidth: bitWidth):
                return LLVMIntegerType(bitWidth: bitWidth.value, in: llvmContext)
            case let .bytePrimitive(bitWidth: bitWidth):
                return LLVMByteType(bitWidth: bitWidth.value, in: llvmContext)
            }
        }
        return llvmType(for: type)
    }
    
    @inlinable
    internal mutating func _insertExternalName(_ name: Identifier) {
        precondition(!_externalNames.contains(name), "The external declaration \"\(name)\" is not uniquely named")
        _externalNames.insert(name)
    }
}
