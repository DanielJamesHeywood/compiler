import LLVM

import Tokens
import Semantics

@usableFromInline
internal final class _FunctionIRGenerator {
    
    @usableFromInline
    internal enum _Kind {
        case initializer(SemanticInitializer)
        case function(SemanticFunction)
    }
    
    @usableFromInline
    internal let _kind: _Kind
    
    @usableFromInline
    internal let _moduleIRGenerator: _ModuleIRGenerator
    
    @usableFromInline
    internal let _llvmBuilder: LLVMBuilder
    
    @inlinable
    internal init(_kind: _Kind, in moduleIRGenerator: _ModuleIRGenerator) {
        guard let llvmModule = moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        self._kind = _kind
        self._moduleIRGenerator = moduleIRGenerator
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
    
    @inlinable
    internal func defineLLVMFunction() {
        guard let llvmModule = _moduleIRGenerator._llvmModule else {
            preconditionFailure("The LLVM module has been taken")
        }
        switch _kind {
        case let .initializer(initializer):
            precondition(
                _moduleIRGenerator._llvmFunctionsForInitializers[initializer] == nil,
                "The initializer is already defined"
            )
            let llvmFunction = llvmModule.addFunction(
                type: _moduleIRGenerator._llvmFunctionType(for: initializer),
                linkage: .internal
            )
            _moduleIRGenerator._llvmFunctionsForInitializers[initializer] = llvmFunction
            guard let body = initializer.body else {
                preconditionFailure("The initializer has no body")
            }
        case let .function(function):
            if function.isExternal {
                _moduleIRGenerator._insertExternalName(function.name)
            } else {
                precondition(
                    _moduleIRGenerator._llvmFunctionsForFunctions[function] == nil,
                    "The function \"\(function.name)\" is already defined"
                )
            }
            let llvmFunction = llvmModule.addFunction(
                function.isExternal ? function.name.text : "",
                type: _moduleIRGenerator._llvmFunctionType(for: function),
                linkage: function.isExternal ? .external : .internal
            )
            _moduleIRGenerator._llvmFunctionsForFunctions[function] = llvmFunction
            if let body = function.body {} else {
                precondition(function.isExternal, "The function \"\(function.name)\" has no body but is not external")
            }
        }
    }
}
