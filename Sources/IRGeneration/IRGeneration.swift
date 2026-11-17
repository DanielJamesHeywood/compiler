import LLVM

import Syntax
import Semantics

extension SemanticModule {
    
    @inlinable
    public func makeLLVMModule(in llvmContext: LLVMContext) -> LLVMModule {
        let generator = _ModuleIRGenerator(in: llvmContext)
        for constant in constants where constant.accessLevel == .public {
            generator.defineGlobalVariable(for: constant)
        }
        for variable in variables where variable.accessLevel == .public {
            generator.defineGlobalVariable(for: variable)
        }
        for function in functions where function.accessLevel == .public && function.isExternal {
            generator.defineFunction(for: function)
        }
        return generator.takeLLVMModule()
    }
}
