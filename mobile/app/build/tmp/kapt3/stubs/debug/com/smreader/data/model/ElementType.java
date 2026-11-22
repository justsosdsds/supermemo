package com.smreader.data.model;

import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.Index;
import androidx.room.PrimaryKey;

/**
 * Element kinds. A whole article is a topic; a cloze or Q&A card is an item.
 */
@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\t\b\u0002\u00a2\u0006\u0004\b\u0002\u0010\u0003j\u0002\b\u0004j\u0002\b\u0005\u00a8\u0006\u0006"}, d2 = {"Lcom/smreader/data/model/ElementType;", "", "<init>", "(Ljava/lang/String;I)V", "TOPIC", "ITEM", "app_debug"})
public enum ElementType {
    /*public static final*/ TOPIC /* = new TOPIC() */,
    /*public static final*/ ITEM /* = new ITEM() */;
    
    ElementType() {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static kotlin.enums.EnumEntries<com.smreader.data.model.ElementType> getEntries() {
        return null;
    }
}