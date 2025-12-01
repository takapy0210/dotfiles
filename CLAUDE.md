# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

macOS用の開発環境設定ファイル(dotfiles)管理リポジトリ。シンボリックリンクベースでシェル設定、Git設定、VSCode設定などを管理。

## アーキテクチャ

### コア設計原則

1. **シンボリックリンク方式**: dotfilesリポジトリ内のファイルをホームディレクトリにシンボリックリンクで配置
2. **バックアップファースト**: 既存ファイルは必ずタイムスタンプ付きディレクトリにバックアップ
3. **機密情報の分離**: `.zshrc.local`でローカル/機密設定を管理(Gitにコミットしない)

### ディレクトリ構造と責務

```
dotfiles/
├── install.sh              # メインインストールスクリプト
├── Brewfile               # パッケージ依存関係定義
├── shell/                 # シェル設定ファイル
│   ├── .zshrc            # メインzsh設定(pecoキーバインド含む)
│   └── .zshrc.local.example  # ローカル設定テンプレート
├── git/                   # Git設定
│   ├── .gitconfig        # Gitエイリアスと設定
│   └── .gitignore_global # グローバル除外パターン
└── config/                # アプリケーション設定
    ├── vscode/           # VSCode設定とスクリプト
    └── ssh/              # SSH設定
```

### 重要な設定ファイル

#### shell/.zshrc

- Oh My Zshプラグイン: git, zsh-autosuggestions, zsh-syntax-highlighting, docker, kubectl, aws
- pecoキーバインド:
  - `Ctrl+R`: 履歴検索
  - `Ctrl+G`: Gitブランチ選択
- pyenv自動初期化
- モダンUNIXツールエイリアス(exa, bat, ripgrep)

#### git/.gitconfig

- デフォルトブランチ: `main`
- エディタ: VSCode (`code --wait`)
- 重要なエイリアス:
  - `git lg`: グラフ付きログ表示
  - `git cleanup`: マージ済みブランチ削除
- diff3マージスタイル、histogramアルゴリズム使用

## 開発タスク

### インストール・セットアップ

```bash
# 初回セットアップ
./install.sh

# VSCode拡張機能の一括インストール
cd config/vscode
./install-extensions.sh

# 拡張機能リストの更新
cd config/vscode
./export-extensions.sh
```

### Brewfile管理

```bash
# パッケージインストール
brew bundle --file=~/dotfiles/Brewfile

# 現在のパッケージをBrewfileに反映
cd ~/dotfiles
brew bundle dump --force
```

### 設定の同期

設定変更後は通常のGitワークフローでコミット・プッシュ:

```bash
cd ~/dotfiles
git add .
git commit -m "Update settings"
git push
```

他のマシンで取得:

```bash
cd ~/dotfiles
git pull
./install.sh
```

## 技術的な注意点

### シンボリックリンク作成ロジック

`install.sh`の`create_symlink`関数:

1. ターゲットディレクトリを確保
2. 既存ファイルをバックアップディレクトリにコピー
3. 既存シンボリックリンクを削除
4. 新しいシンボリックリンクを作成

### Python環境管理

- pyenvでPython 3.13をデフォルトインストール
- `.zshrc`でpyenv自動初期化(52-57行目)
- グローバルバージョンは`pyenv global 3.13`で設定

### VSCode設定の同期

macOSでのVSCode設定ディレクトリ: `~/Library/Application Support/Code/User`

- `settings.json`と`keybindings.json`をシンボリックリンク
- 拡張機能は`extensions.txt`で管理

### SSH設定

- `config/ssh/config`を`~/.ssh/config`にシンボリックリンク
- パーミッションは自動的に600に設定

## 機密情報の扱い

以下は`.zshrc.local`で管理し、**絶対にコミットしない**:

- GitHubトークン
- AWSクレデンシャル
- API鍵
- パスワード

`.zshrc`の最後で`.zshrc.local`を自動読み込み(204-206行目)
