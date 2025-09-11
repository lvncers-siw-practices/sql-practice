# SQL 演習問題 2

## SQL 演習問題解答・解説

### 問 11: 日本の首都圏(東京、神奈川、千葉)の人口

**解説**: name は市区町村、district は都道府県

```sql
SELECT
    SUM(Population) AS CapitalAreaPopulation
FROM
    city
WHERE
    District IN (
        'Tokyo-to',
        'Kanagawa',
        'Chiba'
    );
```

### 全世界の平均寿命

```sql
SELECT
    ROUND(AVG(lifeexpectancy),1) AS World_LifeExpectancy
FROM
    country;
```

### 問 12: 世界の言語の数

**解説**: まず全世界の言語の一覧を重複なしで表示する

```sql
SELECT
    DISTINCT language
FROM
    countrylanguage;
```

それをカウントするから上から全部かぶせれば OK

```sql
SELECT
    COUNT(DISTINCT language) AS LangNum
FROM
    countrylanguage;
```

### 大陸(Continent)毎の平均 GNP

```sql
SELECT
    Continent,
    ROUND(AVG(gnp), 1) AS Continent_GNP
FROM
    country
GROUP BY
    Continent
ORDER BY
    Continent_GNP DESC;
```

### 問 13: 地域毎の平均 GNP

```sql
SELECT
    Region,
    ROUND(AVG(GNP), 2) AS GNP
FROM
    country
GROUP BY
    Region
ORDER BY
    GNP DESC,
    Region;
```

### アジアにおける地域(Region)ごとの人口

```sql
SELECT
    Region,
    SUM(population) AS Population
FROM
    country
WHERE
    continent = "Asia"
GROUP BY
    Region
ORDER BY
    Population DESC;
```

### 問 14: 英語を母国語とする国

```sql
SELECT
    Name
FROM
    country
WHERE
    Code IN
    (
        SELECT
            CountryCode
        FROM
            countrylanguage
        WHERE
            Language = 'English' AND IsOfficial = 'T'
    )
ORDER BY Name;
```

#### 別解

```sql
SELECT
    Country.Code,
    Country.Name,
    CountryLanguage.Language,
    CountryLanguage.IsOfficial
FROM
    Country
INNER JOIN
    CountryLanguage
ON
    Country.Code = CountryLanguage.CountryCode
WHERE
    CountryLanguage.Language = 'English'
    AND CountryLanguage.IsOfficial = 'T';
```

### 問 15: 使用言語の情報が無い国

**解説**:

#### どこを見ればわかるか？

world データベースにおいて使用言語の情報が無い国を見つけるには、以下の 2 つのテーブルの関係性を理解する必要があります：

1. **country テーブル**: 世界の国の情報（239 か国）
2. **countrylanguage テーブル**: 各国の使用言語の情報

#### 確認手順

まず、それぞれのテーブルの件数を確認します：

```sql
-- 国の総数を確認
SELECT COUNT(*) FROM country;
-- 結果: 239

-- 言語情報がある国の数を確認（重複除く）
SELECT COUNT(DISTINCT CountryCode) FROM countrylanguage;
-- 結果: 233
```

この数字の差（239 - 233 = 6）が、使用言語の情報が無い国の数になります。

#### 特定の国を確認する場合

Antarctical など、特定の国が言語情報を持っているかを確認したい場合：

```sql
SELECT
    *
FROM
    country
WHERE
    name = 'Antarctica';
```

**解答**:

```sql
SELECT
    Code,
    Name
FROM
    country AS c
WHERE
    NOT EXISTS
    (
        SELECT
            *
        FROM
            countrylanguage AS cl
        WHERE
            c.Code = cl.countryCode
    )
ORDER BY Code;
```

別解

```sql
SELECT
    c.code AS Code,
    c.Name AS Country
FROM
    country AS c
LEFT JOIN
    countrylanguage AS cl
ON
    c.Code = cl.CountryCode
WHERE
    cl.Language IS NULL
ORDER BY
    c.code,
    c.Name;
```

### 問 16: 人口が多い首都上位 20 ヶ国

**解説**: どうやって city の首都と country を結合するか？

結合条件を工夫する

```sql
INNER JOIN city ON country.Capital = city.ID
```

**解答**:

```sql
SELECT
    country.Name AS CountryName,
    city.Name AS Capital,
    city.Population AS Population
FROM
    country
INNER JOIN
    city
ON
    country.Capital = city.ID
ORDER BY
    Population DESC,
    CountryName
LIMIT 20;
```

### 問 17: 人口が 500 万人以上の国名・都市のビュー (over5million_population)

**解説**: まず都市に人口を出す SQL を実行する

```sql
SELECT
    Name AS City,
    Population
FROM
    city
WHERE
    Population >= 5000000
ORDER BY
    Population DESC;
```

あとは、単純に country と結合して必要なカラムを出力して、
ビューを作れば OK

**解答**:

```sql
CREATE VIEW over5million_population AS
SELECT
    country.Name AS Country,
    city.Name AS City,
    city.Population AS Population
FROM
    country
INNER JOIN
    city
ON
    country.Code = city.CountryCode
WHERE
    city.Population >= 5000000
ORDER BY
    city.Population DESC;
```

必ず確認すること。

```sql
SELECT * FROM over5million_population;
```

### 問 18: 日本の言語に大阪弁を登録

```sql
INSERT INTO countrylanguage
    (
        CountryCode,
        Language,
        IsOfficial,
        Percentage
    )
VALUES
    (
        'JPN',
        'Osaka-ben',
        'F',
        5.0
    );
```

### 問 19: 日本の言語の大阪弁を関西弁に更新

```sql
UPDATE
    countrylanguage
SET
    Language = 'Kansai-ben',
    Percentage = 10.0
WHERE
    CountryCode = 'JPN' AND Language = 'Osaka-ben';
```

### 問 20: 日本の言語の関西弁を削除

```sql
DELETE FROM
    countrylanguage
WHERE
    CountryCode = 'JPN' AND Language = 'Kansai-ben';
```

**問 18 / 問 19 / 問 20 共通の注意点**:
CRUD 操作をしたら必ず確認すること
怖ければ auto_commit をオフにして begin して commit ないし rollback すること

```sql
SELECT * FROM countrylanguage
WHERE
    CountryCode = 'JPN'
    AND Language = 'Kansai-ben';
```

### 問 21: 全世界で使われている言語のうち、使用人口が多い順 20

**解説**: まず確実に人口情報がある country と言語情報がある countrylanguage を脳死で結合する

```sql
SELECT
    *
FROM countrylanguage
    INNER JOIN country ON countrylanguage.CountryCode = country.Code
```

各言語の使用人口を求める。

```sql
SELECT
    Language,
    SUM(Population * (Percentage * 100)) AS langPopulation
FROM countrylanguage
    INNER JOIN country ON countrylanguage.CountryCode = country.Code
GROUP BY
    Language;
```

その人口が全体の何パーセントを占めているかを副問合せを使って計算する。

```sql
SELECT
    Language,
    SUM((Percentage / 100) * Population) AS langPopulation,
    SUM((Percentage / 100) * Population) /
    (
        SELECT SUM(Population)
        FROM country
    ) * 100 AS Percentage
FROM countrylanguage
    INNER JOIN country ON countrylanguage.CountryCode = country.Code
GROUP BY
    Language;
```

あとは、ROUND を使って四捨五入、ORDER BY を使って並び替え、LIMIT を使って 20 件出力されるようにすればいい。

**解答**:

```sql
SELECT Language,
    ROUND(
        SUM(Percentage / 100 * Population),
        0
    ) AS langPopulation,
    ROUND(
        SUM(Percentage / 100 * Population) / (
            SELECT SUM(Population)
            FROM country
        ) * 100,
        1
    ) AS Percentage
FROM countrylanguage
    INNER JOIN country ON countrylanguage.CountryCode = country.Code
GROUP BY Language
ORDER BY langPopulation DESC,
    Language
LIMIT 20;
```

このクエリを実行することで、話者人口が多い言語のランキングを取得することができます。

### 問 22: 国名、首都名、最も使われている公用語、国人口

**解説**: まず、各国の首都別に言語以外に関する必要な情報を取得するのは簡単。

```sql
SELECT
    country.Name AS CountryName,
    country.Code,
    city.name AS Capital,
    SurfaceArea
FROM
    country
LEFT OUTER JOIN
    city
ON
    country.Capital = city.ID
ORDER BY
    CountryName;
```

問題は countrylanguage でその首都別で最も使われている公用語とその話者人口を求めて、結合するのがとにかく難しい。

まず、countrylanguage テーブルから公用語 (IsOfficial = 'T') である言語の中で最大の割合 (MAX(Percentage)) を取得する。

```sql
SELECT
    CountryCode, MAX(Percentage) AS maxPercentage
FROM
    countrylanguage
WHERE
    IsOfficial = 'T'
GROUP BY
    CountryCode;
```

次に、最大の割合を持つ言語とその国コードを取得する。

```sql
SELECT
    t2.CountryCode, t1.Language
FROM
    countrylanguage AS t1
    INNER JOIN
    (
        SELECT
            CountryCode, MAX(Percentage) AS maxPercentage
        FROM
            countrylanguage
        WHERE
            IsOfficial = 'T'
        GROUP BY
            CountryCode
    ) AS t2
    ON t1.CountryCode = t2.CountryCode AND t1.Percentage = t2.maxPercentage
WHERE
    IsOfficial = 'T'
```

このサブクエリは、各国で公用語として最も割合が高い言語を取得するものです。
後は単純にこのサブクエリを city と country に結合し、必要なカラムを取得したら、並び替えるだけ。

**解答**:

```sql
SELECT country.Name AS CountryName,
    country.Code,
    city.name AS Capital,
    Language,
    country.Population,
    SurfaceArea
FROM country
    LEFT OUTER JOIN (
        SELECT t2.CountryCode,
            t1.Language
        FROM countrylanguage AS t1
            INNER JOIN (
                SELECT CountryCode,
                    MAX(Percentage) AS maxPercentage
                FROM countrylanguage
                WHERE IsOfficial = 'T'
                GROUP BY CountryCode
            ) AS t2 ON t1.CountryCode = t2.CountryCode
            AND t1.Percentage = t2.maxPercentage
        WHERE IsOfficial = 'T'
    ) AS tlang ON country.code = tlang.CountryCode
    LEFT OUTER JOIN city ON country.Capital = city.ID
ORDER BY CountryName;
```
