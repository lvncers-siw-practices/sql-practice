# UNION 関数について

```sql
SELECT
    *
FROM
    student
LEFT JOIN
    exam ON student.id = exam.id
UNION
SELECT
    *
FROM
    student
RIGHT JOIN
    exam ON student.id = exam.id;
```

```sql
SELECT
    student.id,
    name,
    平均点
FROM student
    LEFT OUTER JOIN (
        SELECT
            id,
            AVG(score) AS 平均点
        FROM
            exam
        GROUP BY
            id
    ) AS t ON student.id = t.id
ORDER BY
    student.id,
    name;
```

## UNION 関数

```sql
SELECT
    'S' AS 成績,
    COUNT(*) AS 人数
FROM
    exam
WHERE
    score >= 90
UNION
SELECT
    'A' AS 成績,
    COUNT(*) AS 人数
FROM
    exam
WHERE
    score >= 80 AND score < 90
UNION
SELECT
    'B' AS 成績,
    COUNT(*) AS 人数
FROM
    exam
WHERE
    score >= 70 AND score < 80
UNION
SELECT
    'C' AS 成績,
    COUNT(*) AS 人数
FROM
    exam
WHERE
    score >= 60 AND score < 70
UNION
SELECT
    'D' AS 成績,
    COUNT(*) AS 人数
FROM
    exam
WHERE
    score < 60;
```

```powershell
結果画面
+------+------+
| 成績 | 人数 |
+------+------+
| S    |    1 |
| A    |    2 |
| B    |    2 |
| C    |    1 |
| D    |    1 |
+------+------+
5 rows in set (0.00 sec)
```

---

## UNION を使わない集計方法 (CASE + GROUP BY)

以下のクエリでは `CASE` 式で得点を成績に変換し、サブクエリとしてまとめてから `GROUP BY` で人数を集計します。

```sql
SELECT
    grade AS 成績,
    COUNT(*) AS 人数
FROM (
    SELECT
        CASE
            WHEN score >= 90 THEN 'S'
            WHEN score >= 80 THEN 'A'
            WHEN score >= 70 THEN 'B'
            WHEN score >= 60 THEN 'C'
            ELSE 'D'
        END AS grade
    FROM exam
) AS derived
GROUP BY grade
ORDER BY FIELD(grade, 'S', 'A', 'B', 'C', 'D');
```

`UNION` を使用せず 1 回のテーブルスキャンで済むため、パフォーマンス向上が期待できます。

---

```sql
CREATE VIEW school_view AS
SELECT
    student.id,
    name,
    subject,
    score
FROM
    student
INNER JOIN
    exam
ON
    student.id = exam.id
ORDER BY
    id;
```
