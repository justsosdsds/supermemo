package com.smreader.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val Light = lightColorScheme(
    primary = Color(0xFF2F6F6B),
    onPrimary = Color.White,
    secondary = Color(0xFF4F6B8F)
)

private val Dark = darkColorScheme(
    primary = Color(0xFF8FD3CE),
    onPrimary = Color(0xFF003733),
    secondary = Color(0xFFB6C8E8)
)

@Composable
fun SmReaderTheme(dark: Boolean = isSystemInDarkTheme(), content: @Composable () -> Unit) {
    MaterialTheme(colorScheme = if (dark) Dark else Light, content = content)
}
