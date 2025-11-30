# dotfiles

macOS用の開発環境設定ファイル管理リポジトリです。シェル設定、Git設定、VSCode設定など、開発に必要な設定ファイルをまとめて管理します。

## 特徴

- シンボリックリンクによる安全な設定ファイル管理
- 自動バックアップ機能付きインストールスクリプト
- Homebrewによるパッケージ管理
- 機密情報の分離管理
- 複数マシン間での設定同期

## ディレクトリ構成

```
dotfiles/
├── README.md              # このファイル
├── install.sh             # インストールスクリプト
├── Brewfile              # Homebrewパッケージ定義
├── .gitignore            # Git除外設定
├── shell/                # シェル設定
│   ├── .zshrc
│   ├── .bashrc
│   ├── .bash_profile
│   └── .zshrc.local.example  # ローカル設定テンプレート
├── git/                  # Git設定
│   ├── .gitconfig
│   └── .gitignore_global
└── config/               # アプリケーション設定
    ├── vscode/
    │   ├── settings.json
    │   └── keybindings.json
    └── ssh/
        └── config
```

## 必要要件

- macOS (Apple Silicon / Intel対応)
- Homebrew (インストールスクリプトで自動インストール可能)

## インストール方法

### 1. リポジトリをクローン

```bash
git clone https://github.com/takapy0210/dotfiles.git
cd dotfiles
```

### 2. インストールスクリプトを実行

```bash
./install.sh
```

インストールスクリプトは以下の処理を自動的に行います:

1. 既存の設定ファイルをバックアップ
2. Homebrewのインストール (未インストールの場合)
3. Brewfileからパッケージをインストール
4. Oh My Zshのインストール (未インストールの場合)
5. 設定ファイルのシンボリックリンク作成

### 3. ローカル設定ファイルの作成 (オプション)

機密情報や機器固有の設定は、`.zshrc.local`で管理します:

```bash
cp ~/dotfiles/shell/.zshrc.local.example ~/.zshrc.local
```

`.zshrc.local`を編集して、GitHubトークンなどの機密情報を追加します:

```bash
# ~/.zshrc.local
export GITHUB_USER="your-username"
export GITHUB_ACCESS_TOKEN="your-token"
```

**重要**: `.zshrc.local`はGitで管理されません（.gitignoreに含まれています）

### 4. ターミナルを再起動

```bash
# または
source ~/.zshrc
```

## Brewfileについて

[Brewfile](Brewfile)には、開発に必要なパッケージが定義されています。

### 主要なパッケージ

- **シェルツール**: zsh, peco, fzf
- **モダンUNIXツール**: ripgrep, fd, bat, exa
- **Git関連**: git, gh (GitHub CLI)
- **その他**: jq, yq, tree

### パッケージの追加

新しいパッケージをインストールする際は、Brewfileに追記してから:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

## 設定ファイルの説明

### シェル設定

#### `.zshrc`
- Oh My Zshの設定
- pecoによる履歴検索 (Ctrl+R)
- pecoによるGitブランチ選択 (Ctrl+G)
- 便利なエイリアス設定
- モダンなUNIXツールの統合

#### `.bashrc` / `.bash_profile`
- Bash使用時の設定
- 基本的なエイリアスとプロンプト

### Git設定

#### `.gitconfig`
- ユーザー情報
- エディタ設定 (VSCode)
- 便利なエイリアス
  - `git st` → `git status -sb`
  - `git lg` → グラフ付きログ表示
  - `git cleanup` → マージ済みブランチの削除

#### `.gitignore_global`
- グローバルで無視するファイル
- macOS固有ファイル (.DS_Store等)
- エディタ設定ファイル
- 一時ファイル

### VSCode設定

#### `settings.json`
- エディタの基本設定
- 言語別のフォーマッタ設定
- Python, JavaScript, TypeScript等の設定

#### `keybindings.json`

- カスタムキーバインド

#### `extensions.txt`

- インストール済み拡張機能のリスト
- `install-extensions.sh`で一括インストール可能
- `export-extensions.sh`で現在の拡張機能をエクスポート

### SSH設定

#### `config/ssh/config`
- SSH接続の設定
- GitHub用の設定
- サーバー接続のテンプレート

## よくある操作

### 設定の同期

作業用PCと個人PCで設定を同期する場合:

```bash
# 変更をコミット・プッシュ
cd ~/dotfiles
git add .
git commit -m "Update settings"
git push

# 別のPCで最新の設定を取得
cd ~/dotfiles
git pull
./install.sh
```

### 設定の更新

設定ファイルを編集した後:

```bash
# 通常のファイルとして編集
vim ~/dotfiles/shell/.zshrc

# 変更をGitで管理
cd ~/dotfiles
git add shell/.zshrc
git commit -m "Update zsh configuration"
git push
```

### バックアップの確認

インストール時のバックアップは、タイムスタンプ付きディレクトリに保存されます:

```bash
ls -la ~/dotfiles_backup_*
```

### パッケージリストの更新

現在インストールされているパッケージをBrewfileに反映:

```bash
cd ~/dotfiles
brew bundle dump --force
```

### VSCode拡張機能の管理

#### 拡張機能のインストール

```bash
# 全ての拡張機能を一括インストール
cd ~/dotfiles/config/vscode
./install-extensions.sh
```

#### 現在の拡張機能をエクスポート

新しい拡張機能をインストールした後、リストを更新:

```bash
cd ~/dotfiles/config/vscode
./export-extensions.sh
```

#### 手動で拡張機能をインストール

```bash
# extensions.txtから直接インストール
cat ~/dotfiles/config/vscode/extensions.txt | grep -v "^#" | xargs -L 1 code --install-extension
```

## トラブルシューティング

### シンボリックリンクが正しく作成されているか確認

```bash
ls -la ~ | grep "^l"
```

### zshプラグインが動作しない場合

```bash
# Oh My Zshのプラグインを再インストール
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
```

### VSCode設定が反映されない場合

VSCodeを完全に再起動してください。

## セキュリティ上の注意

以下の情報は**絶対にGitにコミットしないでください**:

- APIトークン
- パスワード
- SSH秘密鍵
- AWSクレデンシャル

これらは`.zshrc.local`や環境変数で管理し、`.gitignore`で除外されていることを確認してください。

## カスタマイズ

このdotfilesはベースとなる設定です。以下をカスタマイズして使用してください:

1. `.gitconfig`のユーザー名・メールアドレス
2. Brewfileのパッケージリスト
3. VSCode設定のテーマやフォント
4. シェルエイリアス

## ライセンス

MIT License

## 参考リンク

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [peco](https://github.com/peco/peco)
