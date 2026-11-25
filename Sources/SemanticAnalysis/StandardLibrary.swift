import Tokens
import Syntax

@inlinable
internal var _syntacticStandardLibrary: SyntacticModule {
    SyntacticModule {
        SyntacticDeclaration.structure(
            "Integer32",
            accessLevel: .public,
            isExternal: true,
            conformances: .identifier("Integer")
        ) {
            SyntacticDeclaration.variable("value", accessLevel: .private, type: .integerPrimitive(bitWidth: 32))
            SyntacticDeclaration.initializer(
                accessLevel: .public,
                parameters: SyntacticParameter("literal", label: "_", type: .identifier("IntegerLiteral"))
            ) {
                SyntacticStatement.assignment(
                    of: .primitiveTruncation(
                        of: .primitiveBitCast(
                            of: .member("storage", of: .member("words", of: .identifier("literal"))),
                            to: .integerPrimitive(bitWidth: 64)
                        ),
                        to: .integerPrimitive(bitWidth: 32)
                    ),
                    to: .member("value", of: .self())
                )
            }
        }
        SyntacticDeclaration.structure(
            "UnsignedInteger64",
            accessLevel: .public,
            isExternal: true
        ) {
            SyntacticDeclaration.variable("value", accessLevel: .private, type: .integerPrimitive(bitWidth: 64))
        }
        SyntacticDeclaration.protocol("Integer", accessLevel: .public) {
            SyntacticDeclaration.initializer(
                accessLevel: .public,
                parameters: SyntacticParameter("literal", label: "_", type: .identifier("IntegerLiteral"))
            )
        }
        SyntacticDeclaration.structure("IntegerLiteral", accessLevel: .public) {
            SyntacticDeclaration.structure("Words", accessLevel: .public) {
                SyntacticDeclaration.constant("storage", accessLevel: .private, type: .bytePrimitive(bitWidth: 64))
                SyntacticDeclaration.constant("count", accessLevel: .private, type: .identifier("UnsignedInteger64"))
            }
            SyntacticDeclaration.constant("words", accessLevel: .private, type: .identifier("Words"))
        }
    }
}
