package com.smreader.data.db

import androidx.room.TypeConverter
import com.smreader.data.model.ElementType

class Converters {
    @TypeConverter
    fun toType(v: String): ElementType = ElementType.valueOf(v)

    @TypeConverter
    fun fromType(t: ElementType): String = t.name
}
