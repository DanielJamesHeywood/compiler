import LLVM

import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public func makeLLVMModule(in llvmContext: LLVMContext) -> LLVMModule {
        let generator = _ModuleIRGenerator(in: llvmContext)
        for constant in constants {
            generator.declareGlobalVariable(for: constant)
        }
        for variable in variables {
            generator.declareGlobalVariable(for: variable)
        }
        for function in functions where function.isExternal {
            generator.defineFunction(for: function)
        }
        return generator.takeLLVMModule()
    }
}
