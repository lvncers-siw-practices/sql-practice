# SQL 演習問題 3 回答例

## 1. 3000 円以下の商品

```sql
SELECT
    *
FROM
    items
WHERE
    unit_price <= 3000
ORDER BY
    unit_price DESC, id;
```

## 2. 電話番号が「080」で始まる会員

```sql
SELECT
    id, fullname, telno
FROM
    members
WHERE
    tel LIKE '080%'
ORDER BY
    id;
```

## 3. 商品の平均単価

```sql
SELECT
    ROUND(AVG(unit_price), 0) AS avg_price
FROM
    items;
```

## 4. 会員毎の注⽂回数

```sql
SELECT
    member_id,
    fullname,
    COUNT(*) AS order_count
FROM
    orders
GROUP BY
    member_id,
    fullname
ORDER BY
    order_count DESC,
    member_id;
```

## 5. これまでの注⽂⾦額合計が 10000 円以上の会員

```sql
SELECT
    member_id,
    fullname,
    SUM(total) AS total
FROM
    orders
GROUP BY
    member_id,
    fullname
HAVING
    total >= 10000
ORDER BY
    total DESC;
```

## 6. ⽇毎の注⽂回数と注⽂商品の合計⾦額(送料除く)

```sql
SELECT
    DATE_FORMAT(order_datetime, '%Y-%m-%d') AS order_date,
    COUNT(*) AS order_count,
    SUM(total - shipping) AS order_amount
FROM
    orders
GROUP BY
    order_date
ORDER BY
    order_date;
```

## 7. 注⽂していない会員

```sql
SELECT
    id, fullname
FROM
    members
WHERE
    NOT EXISTS
        (
            SELECT
                *
            FROM
                orders
            WHERE
                members.id = orders.member_id
        );
```

## 8. これまでの注⽂⾦額の合計が 1 番⾼い商品

```sql
SELECT
    item_id,
    item_name,
    SUM(subtotal) AS subtotal
FROM
    order_details
GROUP BY
    item_id, item_name
ORDER BY
    subtotal DESC
LIMIT
    1;
```

別解（MAX 関数と副問合せ使用）

```sql
SELECT
    od.item_id,
    od.item_name,
    SUM(od.subtotal) AS subtotal
FROM
    order_details od
GROUP BY
    od.item_id, od.item_name
HAVING
    SUM(od.subtotal) = (
        SELECT
            MAX(total_subtotal)
        FROM
            (
                SELECT
                    SUM(subtotal) AS total_subtotal
                FROM
                    order_details
                GROUP BY
                    item_id
            ) AS max_subtotal
    );
```

## 9. 会員毎の注⽂状況(ビュー: members_order)

### 冗長な書き方（元のコード）

```sql
CREATE VIEW
    members_order
AS (
    SELECT
        members.id,
        members.fullname,
        mailaddress,
        address,
        COALESCE(order_total, 0) AS order_total,
        COALESCE(order_count, 0) AS order_count,
        COALESCE(item_count, 0) AS item_count,
        lastest_order_datetime
    FROM
        members
    LEFT OUTER JOIN
        (SELECT
            member_id,
            fullname,
            SUM(total) AS order_total,
            COUNT(*) AS order_count,
            MAX(order_datetime) AS lastest_order_datetime
        FROM
            orders
        GROUP BY
            member_id, fullname
        ) AS t1
    ON
        members.id = t1.member_id
    LEFT OUTER JOIN
        (SELECT
            member_id,
            SUM(item_count) AS item_count
        FROM
            (SELECT
                order_id,
                SUM(num) AS item_count
            FROM
                order_details
            GROUP BY
                order_id
            ) AS t2
        INNER JOIN
            orders
        ON
            t2.order_id = orders.id
        GROUP BY
            member_id
        ) as t3
    ON
        members.id = t3.member_id
    ORDER BY
        members.id
    );
```

### 短縮版（推奨）

```sql
CREATE VIEW members_order AS
SELECT
    m.id,
    m.fullname,
    m.mailaddress,
    m.address,
    COALESCE(t1.order_total, 0)   AS order_total,
    COALESCE(t1.order_count, 0)   AS order_count,
    COALESCE(t2.item_count, 0)    AS item_count,
    t1.latest_order_datetime
FROM members AS m
LEFT JOIN (
    SELECT
        member_id,
        SUM(total)          AS order_total,
        COUNT(*)            AS order_count,
        MAX(order_datetime) AS latest_order_datetime
    FROM orders
    GROUP BY member_id
) AS t1 ON m.id = t1.member_id
LEFT JOIN (
    SELECT
        o.member_id,
        SUM(od.num) AS item_count
    FROM orders AS o
    JOIN order_details AS od ON o.id = od.order_id
    GROUP BY o.member_id
) AS t2 ON m.id = t2.member_id
ORDER BY m.id;
```

9 番の問題で発生している重複の問題について解説します。

## 問題の原因

9 番の問題では複数のテーブルを結合して会員ごとの注文状況を表示していますが、単純に結合すると**カルテシアン積**が発生して数値が重複カウントされます。

### 具体例で説明

例えば、会員 ID=1 の田中さんが以下のような注文をしたとします：

**orders テーブル**:

- 注文 1: 合計 1000 円、商品 2 個
- 注文 2: 合計 2000 円、商品 3 個

**order_details テーブル**:

- 注文 1-商品 A: 1 個
- 注文 1-商品 B: 1 個
- 注文 2-商品 C: 3 個

### 単純結合の問題

```sql
-- 問題のあるクエリ例
SELECT
    m.id,
    SUM(o.total) AS order_total,
    SUM(od.num) AS item_count
FROM members m
JOIN orders o ON m.id = o.member_id
JOIN order_details od ON o.id = od.order_id
WHERE m.id = 1
GROUP BY m.id;
```

この場合、結合結果は：

```
member_id | order_total | item_num
1         | 1000        | 1      -- 注文1-商品A
1         | 1000        | 1      -- 注文1-商品B
1         | 2000        | 3      -- 注文2-商品C
```

`SUM(o.total)`を計算すると：1000 + 1000 + 2000 = **4000 円**（正解は 3000 円）

### DISTINCT を使った場合の問題

```sql
SUM(DISTINCT o.total)  -- 1000 + 2000 = 3000円（正解）
```

DISTINCT を使うと重複する値（1000 円）が除外されて正しい結果になります。

**しかし**、もし偶然同じ金額の注文があった場合：

- 注文 1: 1000 円
- 注文 2: 1000 円（偶然同じ金額）

`SUM(DISTINCT o.total)`は 1000 円しか計算せず、実際の 2000 円より少なくなってしまいます。

## 正しい解決方法

9 番の解答で使われている**サブクエリを使った方法**が正解です：

```sql
LEFT JOIN (
    SELECT
        member_id,
        SUM(total) AS order_total,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY member_id
) AS t1 ON m.id = t1.member_id
LEFT JOIN (
    SELECT
        o.member_id,
        SUM(od.num) AS item_count
    FROM orders o
    JOIN order_details od ON o.id = od.order_id
    GROUP BY o.member_id
) AS t2 ON m.id = t2.member_id
```

### なぜこの方法が正しいか

1. **事前集計**: 各サブクエリで先に集計を行う
2. **1 対 1 結合**: 会員テーブルと集計済みデータを 1 対 1 で結合
3. **重複回避**: カルテシアン積が発生しない

この方法により、同じ金額の注文があっても正確に集計できます。

## まとめ

- **単純結合**: カルテシアン積で重複カウント
- **DISTINCT**: たまたま動くが、同じ値があると誤計算
- **サブクエリ事前集計**: 正確で確実な方法

データベース設計では、このような集計の重複問題を避けるために、適切な結合方法を選択することが重要です。

## 10. 商品マスタに登録

```sql
INSERT INTO
    items
    (item_no, item_name, unit_price)
VALUES
    ('SB005', '渦潮の朝', 3800);
```

## 11. 商品マスタを更新

```sql
UPDATE
    items
SET
    item_name = 'うずしお',
    unit_price = 4100
WHERE
    id = 5;
```

## 12. 会員 ID=3 に関するレコードを全てのテーブルから削除(トランザクション)

**注意**: 参照制約がある場合、子要素から先に削除すること

```sql
BEGIN;

DELETE FROM
    order_details
WHERE
    order_id
IN
    (SELECT id FROM orders WHERE member_id = 3);

DELETE FROM orders WHERE member_id = 3;

DELETE FROM members WHERE id = 3;

COMMIT;
```
