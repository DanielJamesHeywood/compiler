@usableFromInline
internal enum _Container: Hashable {
    case module(Weak<SemanticModule>)
    case structure(Weak<SemanticStructure>)
}

extension _Container {

    @inlinable
    internal var module: SemanticModule? {
        if case let .module(weakModule) = self { weakModule.object! } else { nil }
    }

    @inlinable
    internal var structure: SemanticStructure? {
        if case let .structure(weakStructure) = self { weakStructure.object! } else { nil }
    }
}
