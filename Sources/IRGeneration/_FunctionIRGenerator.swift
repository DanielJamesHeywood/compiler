import LLVM

import Semantics

@usableFromInline
internal final class _FunctionIRGenerator {
    
    @usableFromInline
    internal enum _Kind {
        case initializer(SemanticInitializer)
        case function(SemanticFunction)
    }
    
    @usableFromInline
    internal let _moduleIRGenerator: _ModuleIRGenerator
    
    @usableFromInline
    internal let _kind: _Kind
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @inlinable
    internal init(_kind: _Kind, in moduleIRGenerator: _ModuleIRGenerator) {
        guard let llvmModule = moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        self._moduleIRGenerator = moduleIRGenerator
        self._kind = _kind
        self._llvmBuilder = LLVMBuilder(in: llvmModule.context)
    }
    
    @inlinable
    internal convenience init(for initializer: SemanticInitializer, in moduleIRGenerator: _ModuleIRGenerator) {
        self.init(_kind: .initializer(initializer), in: moduleIRGenerator)
    }
    
    @inlinable
    internal convenience init(for function: SemanticFunction, in moduleIRGenerator: _ModuleIRGenerator) {
        self.init(_kind: .function(function), in: moduleIRGenerator)
    }
}
