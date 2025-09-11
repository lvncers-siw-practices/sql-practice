# セットアップ

## 環境変数を通す

1. ウィンドウズのタブでシステムを選択する
2. システム環境変数の Path を選んで編集
3. `C:\Program Files\MySQL\MySQL Server 8.0\bin` 　を追加する
4. システム系をすべて OK にする
5. cmd で mysql コマンドが使えるか確認する

## ダンプファイル取得

```bash
mysql -u root -p school > school.sql
```

注意 : **アクセス拒否された場合**

```bash
mkdir C:\work
cd C:\work
```

**注意**: windows11 の場合はバックスラッシュがルートになるが、10 の場合は円マークになる

work 上で実行する

## ダンプファイル復元

```bash
mysql -u root -p
```

```sql
drop database school;
create database wo;
use school
source C:\school.sql
```

```sql
source C:\world
```

**注意**: source コマンドで;を入れてはいけない
