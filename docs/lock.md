# データベースにおけるロック入門

トランザクション処理では **同時実行制御 (Concurrency Control)** が不可欠です。複数ユーザーが同じデータを同時に読み書きすると整合性が崩れる恐れがあるため、DBMS は **ロック (Lock)** を用いてアクセスを調整します。

---

## 1. ロックの目的

1. **一貫性の保持 (Consistency)** : 同じデータに対する同時更新を防ぎ、ACID の C を実現。
2. **隔離性の確保 (Isolation)** : 同時実行下でも各トランザクションが独立に動作しているように見せる。

---

## 2. ロックの粒度と種類

| 粒度                     | 代表的なロックモード                       | 説明                                 |
| ------------------------ | ------------------------------------------ | ------------------------------------ |
| テーブルロック           | `ACCESS SHARE`, `ROW EXCLUSIVE` など       | テーブル全体に対して取得。           |
| 行ロック                 | `ROW SHARE`, `ROW EXCLUSIVE`, `SHARE` など | 特定行のみロック。高い並行性を実現。 |
| ページロック (一部 DBMS) | -                                          | ディスクページ単位。                 |
| グローバルロック         | `ACCESS EXCLUSIVE`                         | データベース全体を対象にする場合も。 |

> 例: MySQL(InnoDB) ではテーブルロック用に 4 種類 (READ, READ LOCAL, WRITE, LOW_PRIORITY WRITE) があり、行ロックは内部的に共有/排他で管理されます。

### 代表的なロックモード

- **共有ロック (Share/Read Lock)**
  - データ読み取り時に取得。他トランザクションの共有ロックは許容するが、排他ロックはブロック。
- **排他ロック (Exclusive/Write Lock)**
  - データ更新時に取得。読取り・書込みのいずれもブロックする。

---

## 3. ロック獲得の SQL

```sql
-- 行レベル排他ロックを取得
SELECT *
  FROM accounts
 WHERE id = 1
 FOR UPDATE;    -- 取得した行を更新予定

-- 行レベル共有ロックを取得
SELECT *
  FROM accounts
 WHERE id BETWEEN 1 AND 10
 FOR SHARE;     -- 読取り専用

-- テーブルロックを明示的に取得
LOCK TABLE accounts WRITE;  -- テーブル全体を書込みロック
```

> 明示的に `LOCK TABLE` を使わなくても、`UPDATE` / `DELETE` は自動的に必要なロックを取得します。

---

## 4. ロックの確認・解除 (MySQL/InnoDB)

```sql
-- 現在保持 / 待機中のロックを確認 (MySQL 8.0)
SELECT *
  FROM performance_schema.data_locks;

-- 死んでいるプロセスやロックが必要なら KILL で終了
KILL <thread_id>;   -- SUPER 権限が必要

-- InnoDB の詳細状態を確認
SHOW ENGINE INNODB STATUS\G
```

---

## 5. デッドロックとは

相互に資源を奪い合い待機し続ける状態。InnoDB ではデッドロック検出器が自動的に検出し、発生時は一方のトランザクションをロールバックします。

### デッドロック例

```sql
-- セッション A (InnoDB)
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1; -- 行 1 をロック
-- 他セッション B が下記を実行すると…

-- セッション B
BEGIN;
UPDATE accounts SET balance = balance + 100 WHERE id = 2; -- 行 2 をロック

-- A が次に行 2 を更新しようとすると待機
UPDATE accounts SET balance = balance - 100 WHERE id = 2;
-- B が行 1 を更新しようとすると待機
UPDATE accounts SET balance = balance + 100 WHERE id = 1;
-- → 双方待機しデッドロック
```

---

## 6. ベストプラクティス

1. ロック時間を短く保ち、**早期コミット** / **早期ロールバック**。
2. 可能なら **行ロック** を利用し、テーブルロックは最小限に。
3. 一貫した順序でテーブルや行を更新し、デッドロックを回避。
4. 必要に応じて **アドバイザリロック**（アプリケーション定義のロック）を活用。

```sql
-- アドバイザリロックの例
SELECT pg_try_advisory_lock(12345); -- TRUEなら取得成功
-- ... 処理 ...
SELECT pg_advisory_unlock(12345);
```

---

## 7. MyISAM と InnoDB の違い

| 観点               | MyISAM                          | InnoDB                       |
| ------------------ | ------------------------------- | ---------------------------- |
| ロック粒度         | テーブルロックのみ (READ/WRITE) | 行ロック + テーブルロック    |
| トランザクション   | 非対応                          | ACID 準拠、MVCC 対応         |
| 外部キー制約       | 非対応                          | 対応                         |
| クラッシュリカバリ | 修復ツールが必要                | REDO/UNDO ログによる自動復旧 |
| フルテキスト索引   | 対応 (旧式)                     | 5.6 以降対応                 |
| 性能傾向           | 読取性能が高い                  | 書込・同時実行に強い         |

> 大半のユースケースでは InnoDB が推奨されます。MyISAM は読み取り専用や一部旧システム互換用に限られることが多いです。

---

## 8. 参考資料

- MySQL 8.0 Reference Manual: [InnoDB Locking](https://dev.mysql.com/doc/refman/8.0/en/innodb-locking.html)
- MySQL 8.0 Reference Manual: [LOCK TABLES Statement](https://dev.mysql.com/doc/refman/8.0/en/lock-tables.html)

---

> **まとめ**: MySQL でもロック制御は ACID を成立させる鍵です。InnoDB の行ロックと MVCC を活かしつつ、必要に応じてテーブルロックや `LOCK TABLES` を組み合わせ、デッドロックの回避と迅速なコミットを心掛けましょう。
