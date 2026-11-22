package com.smreader;

import android.app.Application;
import com.smreader.data.db.AppDatabase;
import com.smreader.data.repo.ArticleRepository;

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\u0018\u00002\u00020\u0001B\u0007\u00a2\u0006\u0004\b\u0002\u0010\u0003R\u001b\u0010\u0004\u001a\u00020\u00058FX\u0086\u0084\u0002\u00a2\u0006\f\n\u0004\b\b\u0010\t\u001a\u0004\b\u0006\u0010\u0007R\u001b\u0010\n\u001a\u00020\u000b8FX\u0086\u0084\u0002\u00a2\u0006\f\n\u0004\b\u000e\u0010\t\u001a\u0004\b\f\u0010\r\u00a8\u0006\u000f"}, d2 = {"Lcom/smreader/SmApp;", "Landroid/app/Application;", "<init>", "()V", "db", "Lcom/smreader/data/db/AppDatabase;", "getDb", "()Lcom/smreader/data/db/AppDatabase;", "db$delegate", "Lkotlin/Lazy;", "articles", "Lcom/smreader/data/repo/ArticleRepository;", "getArticles", "()Lcom/smreader/data/repo/ArticleRepository;", "articles$delegate", "app_debug"})
public final class SmApp extends android.app.Application {
    @org.jetbrains.annotations.NotNull()
    private final kotlin.Lazy db$delegate = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlin.Lazy articles$delegate = null;
    
    public SmApp() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.smreader.data.db.AppDatabase getDb() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.smreader.data.repo.ArticleRepository getArticles() {
        return null;
    }
}