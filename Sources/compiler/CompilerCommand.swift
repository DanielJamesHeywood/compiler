import ArgumentParser
import SystemPackage
import LLVM

import Lexing
import Parsing

@main
struct CompilerCommand: ParsableCommand {
    
    @Argument(
        help: "The paths to the source files.",
        completion: .file(extensions: ["source"]),
        transform: FilePath.init(_:)
    )
    var sourcePaths: [FilePath]
    
    @Option(help: ArgumentHelp("The target triple.", valueName: "triple"))
    var targetTriple = llvmDefaultTargetTriple
    
    func run() throws {
        precondition(
            sourcePaths.allSatisfy { $0.extension == "source" },
            "Expected the validated source paths to have extension \"source\""
        )
        let contentsOfSourceFiles = try sourcePaths.map { path in
            do {
                let descriptor = try FileDescriptor.open(path, .readOnly)
                return try descriptor.closeAfter {
                    var codeUnits = [] as [UInt8]
                    var isAtEnd = false
                    repeat {
#if os(Windows)
                        let rawFileSize = try descriptor.seek(offset: 0, from: .end)
                        try descriptor.seek(offset: Int64(codeUnits.count), from: .start)
#else
                        let rawFileSize = try descriptor.stat().size
#endif
                        guard let fileSize = Int(exactly: rawFileSize) else {
                            throw StringError("File is larger than \(Int.max) bytes")
                        }
                        if codeUnits.count < fileSize {
                            codeUnits.reserveCapacity(fileSize)
                            try codeUnits.append(addingCapacity: codeUnits.capacity - codeUnits.count) { span in
                                try span.withUnsafeMutableBufferPointer { buffer, initializedCount in
                                    initializedCount = try descriptor.read(into: UnsafeMutableRawBufferPointer(buffer))
                                    if initializedCount == 0 {
                                        isAtEnd = true
                                    }
                                }
                            }
                        } else {
                            isAtEnd = true
                        }
                    } while !isAtEnd
                    do throws(UTF8.ValidationError) {
                        return String(copying: try UTF8Span(validating: codeUnits.span))
                    } catch {
                        let message = switch error.kind {
                        case .invalidNonSurrogateCodePointByte:
                            "UTF-8 validation failed: Invalid non-surrogate code point byte"
                        case .overlongEncodingByte:
                            "UTF-8 validation failed: Overlong encoding byte"
                        case .surrogateCodePointByte:
                            "UTF-8 validation failed: Surrogate code point byte"
                        case .truncatedScalar:
                            "UTF-8 validation failed: Truncated scalar"
                        case .unexpectedContinuationByte:
                            "UTF-8 validation failed: Unexpected continuation byte"
                        default:
                            "UTF-8 validation failed"
                        }
                        throw StringError(message)
                    }
                }
            } catch {
                throw StringError("Failed to read '\(path)': \(error)")
            }
        }
        let tokensForSourceFiles = try zip(sourcePaths, contentsOfSourceFiles).map { path, contents in
            do {
                return try tokens(for: contents)
            } catch {
                throw StringError("Failed to compile '\(path)': \(error)")
            }
        }
        let syntacticDeclarationsForSourceFiles = try zip(sourcePaths, tokensForSourceFiles).map { path, tokens in
            do {
                return try syntacticDeclarations(for: tokens)
            } catch {
                throw StringError("Failed to compile '\(path)': \(error)")
            }
        }
        _ = syntacticDeclarationsForSourceFiles
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
