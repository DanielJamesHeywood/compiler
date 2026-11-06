@usableFromInline
internal enum _Container: Hashable {
    case module(Weak<SemanticModule>)
    case structure(Weak<SemanticStructure>)
}
