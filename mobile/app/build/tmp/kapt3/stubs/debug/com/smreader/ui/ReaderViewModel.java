package com.smreader.ui;

import androidx.lifecycle.ViewModel;
import com.smreader.data.model.Element;
import com.smreader.data.repo.ArticleRepository;
import kotlinx.coroutines.flow.SharingStarted;
import kotlinx.coroutines.flow.StateFlow;

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\u0018\u00002\u00020\u0001B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0004\b\u0004\u0010\u0005J\u000e\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0012J\u000e\u0010\u0017\u001a\u00020\u00152\u0006\u0010\u0018\u001a\u00020\u000eR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0016\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0019\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\n\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000e0\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u000e0\n\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\fR\u0012\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e\u00a2\u0006\u0004\n\u0002\u0010\u0013\u00a8\u0006\u0019"}, d2 = {"Lcom/smreader/ui/ReaderViewModel;", "Landroidx/lifecycle/ViewModel;", "repo", "Lcom/smreader/data/repo/ArticleRepository;", "<init>", "(Lcom/smreader/data/repo/ArticleRepository;)V", "_element", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/smreader/data/model/Element;", "element", "Lkotlinx/coroutines/flow/StateFlow;", "getElement", "()Lkotlinx/coroutines/flow/StateFlow;", "_savedOffset", "", "savedOffset", "getSavedOffset", "loadedId", "", "Ljava/lang/Long;", "load", "", "id", "saveOffset", "offset", "app_debug"})
public final class ReaderViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.smreader.data.repo.ArticleRepository repo = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.smreader.data.model.Element> _element = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.smreader.data.model.Element> element = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.lang.Integer> _savedOffset = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.lang.Integer> savedOffset = null;
    @org.jetbrains.annotations.Nullable()
    private java.lang.Long loadedId;
    
    public ReaderViewModel(@org.jetbrains.annotations.NotNull()
    com.smreader.data.repo.ArticleRepository repo) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.smreader.data.model.Element> getElement() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.lang.Integer> getSavedOffset() {
        return null;
    }
    
    public final void load(long id) {
    }
    
    /**
     * Persist the reading offset. Called on scroll stop and on leave.
     */
    public final void saveOffset(int offset) {
    }
}