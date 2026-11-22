package com.smreader.domain;

/**
 * Pure text handling for imports. No Android dependencies so it can be unit
 * tested on the JVM.
 */
@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0012\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\b\u00c6\u0002\u0018\u00002\u00020\u0001B\t\b\u0002\u00a2\u0006\u0004\b\u0002\u0010\u0003J\u000e\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0005J\u0018\u0010\u0007\u001a\u00020\u00052\u0006\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\nJ\u001a\u0010\u000b\u001a\u00020\u00052\u0006\u0010\f\u001a\u00020\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u0005J \u0010\u000f\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00050\u00110\u00102\u0006\u0010\u0012\u001a\u00020\u0005\u00a8\u0006\u0013"}, d2 = {"Lcom/smreader/domain/TextImport;", "", "<init>", "()V", "normalise", "", "raw", "titleOf", "text", "maxLen", "", "decode", "bytes", "", "fallbackCharset", "paragraphs", "", "Lkotlin/Pair;", "body", "app_debug"})
public final class TextImport {
    @org.jetbrains.annotations.NotNull()
    public static final com.smreader.domain.TextImport INSTANCE = null;
    
    private TextImport() {
        super();
    }
    
    /**
     * Normalise line endings and trim.
     *
     * Offsets stored for reading positions and cloze ranges must be stable, so
     * CRLF and lone CR are folded to LF before anything computes an index.
     */
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String normalise(@org.jetbrains.annotations.NotNull()
    java.lang.String raw) {
        return null;
    }
    
    /**
     * Build a display title from the body: first non-blank line, capped so a
     * whole paragraph cannot become the title.
     */
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String titleOf(@org.jetbrains.annotations.NotNull()
    java.lang.String text, int maxLen) {
        return null;
    }
    
    /**
     * Decode bytes to text. UTF-8 is tried first; if the result contains the
     * replacement character the platform default charset is used instead, which
     * is what Chinese Windows users' GBK-encoded .txt files need.
     */
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String decode(@org.jetbrains.annotations.NotNull()
    byte[] bytes, @org.jetbrains.annotations.Nullable()
    java.lang.String fallbackCharset) {
        return null;
    }
    
    /**
     * Split a body into paragraphs with their character start offsets.
     */
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<kotlin.Pair<java.lang.Integer, java.lang.String>> paragraphs(@org.jetbrains.annotations.NotNull()
    java.lang.String body) {
        return null;
    }
}