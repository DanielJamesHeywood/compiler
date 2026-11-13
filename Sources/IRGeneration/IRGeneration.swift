import LLVM

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
