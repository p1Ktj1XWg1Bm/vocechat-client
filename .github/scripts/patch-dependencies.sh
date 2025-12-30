#!/bin/bash

# 修补第三方依赖以兼容 Flutter 3.16+ 和 Android Gradle 8+
# 这个脚本在 CI/CD 构建前自动修复第三方包的兼容性问题

echo "🔧 Patching third-party dependencies for compatibility..."

# 1. 修补 wechat_picker_library
echo ""
echo "📦 Patching wechat_picker_library..."
WECHAT_LIB_PATH="$HOME/.pub-cache/hosted/pub.dev/wechat_picker_library-1.0.6"

if [ -d "$WECHAT_LIB_PATH" ]; then
    echo "✓ Found wechat_picker_library at: $WECHAT_LIB_PATH"

    # 修复 extensions.dart - 将 toARGB32() 替换为 value
    if [ -f "$WECHAT_LIB_PATH/lib/src/extensions.dart" ]; then
        sed -i 's/toARGB32()/value/g' "$WECHAT_LIB_PATH/lib/src/extensions.dart"
        echo "✓ Patched extensions.dart (toARGB32 -> value)"
    fi

    # 修复 themes.dart - 将 WidgetStateProperty 替换为 MaterialStateProperty
    if [ -f "$WECHAT_LIB_PATH/lib/src/themes.dart" ]; then
        sed -i 's/WidgetStateProperty/MaterialStateProperty/g' "$WECHAT_LIB_PATH/lib/src/themes.dart"
        sed -i 's/WidgetState\./MaterialState./g' "$WECHAT_LIB_PATH/lib/src/themes.dart"
        echo "✓ Patched themes.dart (WidgetStateProperty -> MaterialStateProperty)"
    fi
else
    echo "⚠️  wechat_picker_library not found"
fi

# 2. 修补 connectivity_plus - 移除 AndroidManifest.xml 中的 package 属性
echo ""
echo "📦 Patching connectivity_plus..."
CONNECTIVITY_PATH="$HOME/.pub-cache/hosted/pub.dev/connectivity_plus-3.0.3"

if [ -d "$CONNECTIVITY_PATH" ]; then
    echo "✓ Found connectivity_plus at: $CONNECTIVITY_PATH"

    MANIFEST_FILE="$CONNECTIVITY_PATH/android/src/main/AndroidManifest.xml"
    if [ -f "$MANIFEST_FILE" ]; then
        # 移除 package 属性，但保留 xmlns:android
        sed -i 's/<manifest[^>]*package="[^"]*"/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$MANIFEST_FILE"
        echo "✓ Patched AndroidManifest.xml (removed package attribute)"
    fi
else
    echo "⚠️  connectivity_plus not found"
fi

# 3. 修补 flutter_pdfview - 移除 AndroidManifest.xml 中的 package 属性
echo ""
echo "📦 Patching flutter_pdfview..."
PDFVIEW_PATH="$HOME/.pub-cache/hosted/pub.dev/flutter_pdfview-1.2.9"

if [ -d "$PDFVIEW_PATH" ]; then
    echo "✓ Found flutter_pdfview at: $PDFVIEW_PATH"

    MANIFEST_FILE="$PDFVIEW_PATH/android/src/main/AndroidManifest.xml"
    if [ -f "$MANIFEST_FILE" ]; then
        # 移除 package 属性，但保留 xmlns:android
        sed -i 's/<manifest[^>]*package="[^"]*"/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android"/g' "$MANIFEST_FILE"
        echo "✓ Patched AndroidManifest.xml (removed package attribute)"
    fi
else
    echo "⚠️  flutter_pdfview not found"
fi

echo ""
echo "✅ All patches completed successfully!"
