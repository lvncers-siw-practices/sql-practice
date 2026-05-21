# SQL 演習問題(1)の解答例

## 1. 日本の国の情報

```sql
SELECT
    *
FROM
    country
WHERE
    Code = 'JPN';
```

`Name = 'Japan'` でも結果は同じになるが、 `Code` は PRIMARY KEY なので重複することはなくこちらの方が安全。

## 2. 面積(SurfaceArea)が広い国上位 10 ヶ国

```sql
SELECT
    Name,
    SurfaceArea
FROM
    country
ORDER BY
    SurfaceArea DESC
LIMIT 10;
```

## 3. 平均寿命(LifeExpectancy)が 80 歳以上の国

```sql
SELECT
    Name,
    LifeExpectancy
FROM
    country
WHERE
    LifeExpectancy >= 80
ORDER BY
    LifeExpectancy DESC;
```

## 4. 地域(Region)の一覧

```sql
SELECT
    DISTINCT Region
FROM
    country
ORDER BY
    Region;
```

## 5. 人口(Population)が 500 万人以上 800 万人以下の都市

```sql
SELECT
    CountryCode,
    Name,
    Population
FROM
    city
WHERE
    Population BETWEEN 5000000 AND 8000000
ORDER BY
    Population DESC;
```

## 6. new が含まれる世界の都市

```sql
SELECT
    Name,
    CountryCode,
    District,
    Population
FROM
    city
WHERE
    Name LIKE '%new%'
ORDER BY
    Name;
```

## 7. 独立年(IndepYear)が不明の国

```sql
SELECT
    Code,
    Name,
    IndepYear
FROM
    country
WHERE
    IndepYear IS NULL
ORDER BY
    Code;
```

## 8. 日本語が公用語(IsOfficial)ではない国の一覧

```sql
SELECT
    *
FROM
    countrylanguage
WHERE
    Language = 'Japanese'
    AND IsOfficial != 'T'
ORDER BY
    Percentage DESC;
```

## 9. GNP が 150%以上アップしている国

```sql
SELECT
    Name,
    GNP,
    GNPOld,
    (GNP / GNPOld) * 100 AS Percentage
FROM
    country
WHERE
    (GNP / GNPOld) >= 1.5
ORDER BY
    Percentage DESC;
```

## 10. 公用語が英語、中国語、スペイン語のいずれかで比率が 0.0 以外の一覧

```sql
SELECT
    *
FROM
    countrylanguage
WHERE
    Language IN (
        'English',
        'Chinese',
        'Spanish'
    )
    AND IsOfficial = 'T'
    AND Percentage != 0.0
ORDER BY
    Percentage DESC,
    CountryCode ASC;
```
