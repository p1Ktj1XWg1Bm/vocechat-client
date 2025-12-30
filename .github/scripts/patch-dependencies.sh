#!/bin/bash

# 修补 wechat_picker_library 以兼容 Flutter 3.16+
# 这个脚本在 CI/CD 构建前自动修复第三方包的兼容性问题

echo "🔧 Patching wechat_picker_library for Flutter 3.16+ compatibility..."

# 查找 wechat_picker_library 的路径
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

    echo "✅ Patching completed successfully!"
else
    echo "⚠️  wechat_picker_library not found at expected path"
    echo "   This might happen if the dependency hasn't been downloaded yet"
fi
