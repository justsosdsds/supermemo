package com.smreader

import android.app.Application
import com.smreader.data.db.AppDatabase
import com.smreader.data.repo.ArticleRepository

class SmApp : Application() {
    val db: AppDatabase by lazy { AppDatabase.get(this) }
    val articles: ArticleRepository by lazy { ArticleRepository(db) }
}
