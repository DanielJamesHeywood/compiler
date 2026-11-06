public enum SemanticContainer: Hashable {
    case module(Weak<SemanticModule>)
    case structure(Weak<SemanticStructure>)
}
