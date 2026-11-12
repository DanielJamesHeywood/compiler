import LLVM

import Semantics
import Tokens

@usableFromInline
internal struct _IRGenerator: ~Copyable {
    
    @usableFromInline
    internal let llvmContext: LLVMContext
    
    @usableFromInline
    internal let _llvmModule: LLVMModule
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @usableFromInline
    internal var _externalNames = [] as Set<Identifier>
    
    @usableFromInline
    internal var _llvmGlobalVariablesForConstants = [:] as [SemanticConstant: LLVMGlobalVariable]
    
    @usableFromInline
    internal var _llvmGlobalVariablesForVariables = [:] as [SemanticVariable: LLVMGlobalVariable]
    
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
            type: constant.type._llvmType(in: llvmContext)
        )
    }
    
    @inlinable
    internal mutating func declareGlobalVariable(for variable: SemanticVariable) {
        precondition(variable.isExternal, "The variable \"\(variable.name)\" is not external")
        _insertExternalName(variable.name)
        _llvmGlobalVariablesForVariables[variable] = _llvmModule.addGlobal(
            variable.name.text,
            type: variable.type._llvmType(in: llvmContext)
        )
    }
    
    @inlinable
    internal mutating func _insertExternalName(_ name: Identifier) {
        precondition(!_externalNames.contains(name), "The external declaration \"\(name)\" is not uniquely named")
        _externalNames.insert(name)
    }
    
    @inlinable
    internal consuming func takeLLVMModule() -> LLVMModule { _llvmModule }
}
