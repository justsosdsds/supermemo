package com.smreader.data.repo;

import com.smreader.data.db.AppDatabase;
import com.smreader.data.model.Element;
import com.smreader.data.model.ElementType;
import kotlinx.coroutines.flow.Flow;

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\u0018\u00002\u00020\u0001B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0004\b\u0004\u0010\u0005J\u0012\u0010\n\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\r0\f0\u000bJ\u0016\u0010\u000e\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\r0\u000b2\u0006\u0010\u000f\u001a\u00020\u0010J\u0018\u0010\u0011\u001a\u0004\u0018\u00010\r2\u0006\u0010\u000f\u001a\u00020\u0010H\u0086@\u00a2\u0006\u0002\u0010\u0012J\u0016\u0010\u0013\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\u0015H\u0086@\u00a2\u0006\u0002\u0010\u0016J\u001e\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00102\u0006\u0010\u001a\u001a\u00020\u001bH\u0086@\u00a2\u0006\u0002\u0010\u001cJ\u0016\u0010\u001d\u001a\u00020\u001b2\u0006\u0010\u0019\u001a\u00020\u0010H\u0086@\u00a2\u0006\u0002\u0010\u0012J\u0016\u0010\u001e\u001a\u00020\u00182\u0006\u0010\u000f\u001a\u00020\u0010H\u0086@\u00a2\u0006\u0002\u0010\u0012R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u001f"}, d2 = {"Lcom/smreader/data/repo/ArticleRepository;", "", "db", "Lcom/smreader/data/db/AppDatabase;", "<init>", "(Lcom/smreader/data/db/AppDatabase;)V", "elements", "Lcom/smreader/data/db/ElementDao;", "positions", "Lcom/smreader/data/db/ReadingPositionDao;", "observeArticles", "Lkotlinx/coroutines/flow/Flow;", "", "Lcom/smreader/data/model/Element;", "observeElement", "id", "", "get", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "importText", "raw", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "savePosition", "", "elementId", "offset", "", "(JILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "loadPosition", "delete", "app_debug"})
public final class ArticleRepository {
    @org.jetbrains.annotations.NotNull()
    private final com.smreader.data.db.AppDatabase db = null;
    @org.jetbrains.annotations.NotNull()
    private final com.smreader.data.db.ElementDao elements = null;
    @org.jetbrains.annotations.NotNull()
    private final com.smreader.data.db.ReadingPositionDao positions = null;
    
    public ArticleRepository(@org.jetbrains.annotations.NotNull()
    com.smreader.data.db.AppDatabase db) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<java.util.List<com.smreader.data.model.Element>> observeArticles() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<com.smreader.data.model.Element> observeElement(long id) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object get(long id, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super com.smreader.data.model.Element> $completion) {
        return null;
    }
    
    /**
     * Import plain text as a new root topic.
     *
     * The first non-blank line becomes the title; the whole text is kept as the
     * body so nothing is lost. CRLF and CR are normalised to LF so offsets stay
     * consistent across platforms.
     */
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object importText(@org.jetbrains.annotations.NotNull()
    java.lang.String raw, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.lang.Long> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object savePosition(long elementId, int offset, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object loadPosition(long elementId, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.lang.Integer> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object delete(long id, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
}