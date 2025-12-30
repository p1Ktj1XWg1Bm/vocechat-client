# GitHub Actions 自动构建指南

## 基本使用

### 1. 推送代码后自动构建
当你推送代码到 `master` 或 `develop` 分支时，GitHub Actions 会自动开始构建。

### 2. 手动触发构建
1. 访问 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 选择左侧的 **Build Android APK** workflow
4. 点击右上角的 **Run workflow** 按钮
5. 选择分支，点击 **Run workflow**

### 3. 下载构建的 APK
1. 进入 **Actions** 标签
2. 点击对应的 workflow 运行记录
3. 滚动到页面底部的 **Artifacts** 区域
4. 点击 `vocechat-debug-apk` 下载 APK 文件

## 构建 Release 版本

如果需要构建 Release 版本（正式发布版），需要配置签名：

### 1. 生成签名密钥（如果还没有）
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. 配置 GitHub Secrets
1. 将 `upload-keystore.jks` 文件转换为 Base64:
   ```bash
   base64 ~/upload-keystore.jks > keystore-base64.txt
   ```

2. 在 GitHub 仓库中设置 Secrets:
   - 访问仓库的 **Settings** → **Secrets and variables** → **Actions**
   - 添加以下 secrets:
     - `KEYSTORE_BASE64`: keystore 文件的 Base64 编码内容
     - `KEYSTORE_PASSWORD`: keystore 密码
     - `KEY_ALIAS`: 密钥别名（如 upload）
     - `KEY_PASSWORD`: 密钥密码

3. 在 `build-android.yml` 中取消注释 Release 构建部分，并添加签名配置

## 故障排除

### 构建失败
- 查看 Actions 日志，检查具体错误信息
- 确保 `pubspec.yaml` 中的依赖版本正确
- 检查是否需要更新 Flutter 版本

### 构建时间过长
- GitHub Actions 免费账户有每月 2000 分钟限制
- 可以通过缓存依赖来加快构建速度（workflow 中已启用）

## 优势

✅ **环境一致性**: 每次在干净的 Ubuntu 环境中构建，避免本地环境问题
✅ **自动化**: 推送代码即自动构建，无需本地操作
✅ **多人协作**: 团队成员都能下载最新构建的 APK
✅ **历史记录**: 保留所有构建历史和产物
