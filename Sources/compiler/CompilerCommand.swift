import ArgumentParser
import SystemPackage

@main
struct CompilerCommand: ParsableCommand {
    
    @Argument(
        help: "The paths to the source files.",
        completion: .file(extensions: ["source"]),
        transform: { FilePath($0) }
    )
    var sourcePaths: [FilePath]
    
    func run() throws {
        precondition(
            sourcePaths.allSatisfy { $0.extension == "source" },
            "Expected the validated source paths to have extension \"source\""
        )
    }
    
    func validate() throws {
        for path in sourcePaths {
            guard let `extension` = path.extension else {
                throw ValidationError(
                    "Expected '\(path)' to have extension 'source', but it has no extension"
                )
            }
            guard `extension` == "source" else {
                throw ValidationError(
                    "Expected '\(path)' to have extension 'source', but it has extension '\(`extension`)'"
                )
            }
        }
    }
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "compiler",
            abstract: "Compiler for Daniel James Heywood's 3rd year project.",
            version: "1.0.0",
            helpNames: .long
        )
    }
}

struct StringError: Error, CustomStringConvertible {
    
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var description: String { message }
}
