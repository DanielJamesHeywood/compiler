import LLVM

@usableFromInline
internal final class _FunctionIRGenerator {
    
    @usableFromInline
    internal let _moduleIRGenerator: _ModuleIRGenerator
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @inlinable
    internal init(in moduleIRGenerator: _ModuleIRGenerator) {
        guard let llvmModule = moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        self._moduleIRGenerator = moduleIRGenerator
        self._llvmBuilder = LLVMBuilder(in: llvmModule.context)
    }
}
