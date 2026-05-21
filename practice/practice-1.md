# SQL 演習問題(1)の解答例

## 1. 日本の国の情報

```sh
+------+-------+-----------+--------------+-------------+-----------+------------+----------------+------------+------------+--------------+-------------------------+-------------+---------+-------+
| Code | Name  | Continent | Region       | SurfaceArea | IndepYear | Population | LifeExpectancy | GNP        | GNPOld     | LocalName    | GovernmentForm          | HeadOfState | Capital | Code2 |
+------+-------+-----------+--------------+-------------+-----------+------------+----------------+------------+------------+--------------+-------------------------+-------------+---------+-------+
| JPN  | Japan | Asia      | Eastern Asia |   377829.00 |      -660 |  126714000 |           80.7 | 3787042.00 | 4192638.00 | Nihon/Nippon | Constitutional Monarchy | Akihito     |    1532 | JP    |
+------+-------+-----------+--------------+-------------+-----------+------------+----------------+------------+------------+--------------+-------------------------+-------------+---------+-------+
1 row in set (0.029 sec)
```

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

```sh
+--------------------+-------------+
| Name               | SurfaceArea |
+--------------------+-------------+
| Russian Federation | 17075400.00 |
| Antarctica         | 13120000.00 |
| Canada             |  9970610.00 |
| China              |  9572900.00 |
| United States      |  9363520.00 |
| Brazil             |  8547403.00 |
| Australia          |  7741220.00 |
| India              |  3287263.00 |
| Argentina          |  2780400.00 |
| Kazakstan          |  2724900.00 |
+--------------------+-------------+
10 rows in set (0.003 sec)
```

```sql
SELECT
    Name,
    SurfaceArea
FROM
    country
ORDER BY
    SurfaceArea DESC,
    Name
LIMIT 10;
```

## 3. 平均寿命(LifeExpectancy)が 80 歳以上の国

```sh
+------------+----------------+
| Name       | LifeExpectancy |
+------------+----------------+
| Andorra    |           83.5 |
| Macao      |           81.6 |
| San Marino |           81.1 |
| Japan      |           80.7 |
| Singapore  |           80.1 |
+------------+----------------+
5 rows in set (0.003 sec)
```

```sql
SELECT
    Name,
    LifeExpectancy
FROM
    country
WHERE
    LifeExpectancy >= 80
ORDER BY
    LifeExpectancy DESC,
    Name;
```

## 4. 地域(Region)の一覧

```sh
+---------------------------+
| Region                    |
+---------------------------+
| Antarctica                |
| Australia and New Zealand |
| Baltic Countries          |
| British Islands           |
| Caribbean                 |
| Central Africa            |
| Central America           |
| Eastern Africa            |
| Eastern Asia              |
| Eastern Europe            |
| Melanesia                 |
| Micronesia                |
| Micronesia/Caribbean      |
| Middle East               |
| Nordic Countries          |
| North America             |
| Northern Africa           |
| Polynesia                 |
| South America             |
| Southeast Asia            |
| Southern Africa           |
| Southern and Central Asia |
| Southern Europe           |
| Western Africa            |
| Western Europe            |
+---------------------------+
25 rows in set (0.003 sec)
```

```sql
SELECT
    DISTINCT Region
FROM
    country
ORDER BY
    Region;
```

## 5. 人口(Population)が 500 万人以上 800 万人以下の都市

```sh
+-------------+---------------------+------------+
| CountryCode | Name                | Population |
+-------------+---------------------+------------+
| JPN         | Tokyo               |    7980230 |
| CHN         | Peking              |    7472000 |
| GBR         | London              |    7285000 |
| IND         | Delhi               |    7206704 |
| EGY         | Cairo               |    6789479 |
| IRN         | Teheran             |    6758845 |
| PER         | Lima                |    6464693 |
| CHN         | Chongqing           |    6351600 |
| THA         | Bangkok             |    6320174 |
| COL         | Santafé de Bogotá   |    6260862 |
| BRA         | Rio de Janeiro      |    5598953 |
| CHN         | Tianjin             |    5286800 |
| COD         | Kinshasa            |    5064000 |
| PAK         | Lahore              |    5063499 |
+-------------+---------------------+------------+
14 rows in set (0.004 sec)
```

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
    Population DESC,
    CountryCode;
```

## 6. new が含まれる世界の都市

```sh
+-------------------------+-------------+----------------------+------------+
| Name                    | CountryCode | District             | Population |
+-------------------------+-------------+----------------------+------------+
| Khanewal                | PAK         | Punjab               |     133000 |
| Kowloon and New Kowloon | HKG         | Kowloon and New Kowl |    1987996 |
| New Bedford             | USA         | Massachusetts        |      94780 |
| New Bombay              | IND         | Maharashtra          |     307297 |
| New Delhi               | IND         | Delhi                |     301297 |
| New Haven               | USA         | Connecticut          |     123626 |
| New Orleans             | USA         | Louisiana            |     484674 |
| New York                | USA         | New York             |    8008278 |
| Newark                  | USA         | New Jersey           |     273546 |
| Newcastle               | AUS         | New South Wales      |     270324 |
| Newcastle               | ZAF         | KwaZulu-Natal        |     222993 |
| Newcastle upon Tyne     | GBR         | England              |     189150 |
| Newport                 | GBR         | Wales                |     139000 |
| Newport News            | USA         | Virginia             |     180150 |
+-------------------------+-------------+----------------------+------------+
14 rows in set (0.006 sec)
```

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

```sh
+------+----------------------------------------------+-----------+
| Code | Name                                         | IndepYear |
+------+----------------------------------------------+-----------+
| ABW  | Aruba                                        |      NULL |
| AIA  | Anguilla                                     |      NULL |
| ANT  | Netherlands Antilles                         |      NULL |
| ASM  | American Samoa                               |      NULL |
| ATA  | Antarctica                                   |      NULL |
| ATF  | French Southern territories                  |      NULL |
| BMU  | Bermuda                                      |      NULL |
| BVT  | Bouvet Island                                |      NULL |
| CCK  | Cocos (Keeling) Islands                      |      NULL |
| COK  | Cook Islands                                 |      NULL |
| CXR  | Christmas Island                             |      NULL |
| CYM  | Cayman Islands                               |      NULL |
| ESH  | Western Sahara                               |      NULL |
| FLK  | Falkland Islands                             |      NULL |
| FRO  | Faroe Islands                                |      NULL |
| GIB  | Gibraltar                                    |      NULL |
| GLP  | Guadeloupe                                   |      NULL |
| GRL  | Greenland                                    |      NULL |
| GUF  | French Guiana                                |      NULL |
| GUM  | Guam                                         |      NULL |
| HKG  | Hong Kong                                    |      NULL |
| HMD  | Heard Island and McDonald Islands            |      NULL |
| IOT  | British Indian Ocean Territory               |      NULL |
| MAC  | Macao                                        |      NULL |
| MNP  | Northern Mariana Islands                     |      NULL |
| MSR  | Montserrat                                   |      NULL |
| MTQ  | Martinique                                   |      NULL |
| MYT  | Mayotte                                      |      NULL |
| NCL  | New Caledonia                                |      NULL |
| NFK  | Norfolk Island                               |      NULL |
| NIU  | Niue                                         |      NULL |
| PCN  | Pitcairn                                     |      NULL |
| PRI  | Puerto Rico                                  |      NULL |
| PSE  | Palestine                                    |      NULL |
| PYF  | French Polynesia                             |      NULL |
| REU  | Réunion                                      |      NULL |
| SGS  | South Georgia and the South Sandwich Islands |      NULL |
| SHN  | Saint Helena                                 |      NULL |
| SJM  | Svalbard and Jan Mayen                       |      NULL |
| SPM  | Saint Pierre and Miquelon                    |      NULL |
| TCA  | Turks and Caicos Islands                     |      NULL |
| TKL  | Tokelau                                      |      NULL |
| TMP  | East Timor                                   |      NULL |
| UMI  | United States Minor Outlying Islands         |      NULL |
| VGB  | Virgin Islands, British                      |      NULL |
| VIR  | Virgin Islands, U.S.                         |      NULL |
| WLF  | Wallis and Futuna                            |      NULL |
+------+----------------------------------------------+-----------+
47 rows in set (0.001 sec)
```

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

```sh
+-------------+----------+------------+------------+
| CountryCode | Language | IsOfficial | Percentage |
+-------------+----------+------------+------------+
| GUM         | Japanese | F          |        2.0 |
| BRA         | Japanese | F          |        0.4 |
| USA         | Japanese | F          |        0.2 |
+-------------+----------+------------+------------+
3 rows in set (0.001 sec)
```

```sql
SELECT
    *
FROM
    countrylanguage
WHERE
    Language = 'Japanese'
    AND IsOfficial != 'T'
ORDER BY
    Percentage DESC,
    CountryCode;
```

## 9. 地域がMelanesiaとMicronesiaとPolynesiaの国 (2026ver)

```sh
+---------------------------------+------------+
| name                            | region     |
+---------------------------------+------------+
| Fiji Islands                    | Melanesia  |
| New Caledonia                   | Melanesia  |
| Papua New Guinea                | Melanesia  |
| Solomon Islands                 | Melanesia  |
| Vanuatu                         | Melanesia  |
| Guam                            | Micronesia |
| Kiribati                        | Micronesia |
| Marshall Islands                | Micronesia |
| Micronesia, Federated States of | Micronesia |
| Nauru                           | Micronesia |
| Northern Mariana Islands        | Micronesia |
| Palau                           | Micronesia |
| American Samoa                  | Polynesia  |
| Cook Islands                    | Polynesia  |
| French Polynesia                | Polynesia  |
| Niue                            | Polynesia  |
| Pitcairn                        | Polynesia  |
| Samoa                           | Polynesia  |
| Tokelau                         | Polynesia  |
| Tonga                           | Polynesia  |
| Tuvalu                          | Polynesia  |
| Wallis and Futuna               | Polynesia  |
+---------------------------------+------------+
22 rows in set (0.001 sec)
```

```sql
SELECT
   name,
   region
FROM
   country
WHERE
   region IN ('melanesia', 'micronesia', 'polynesia')
ORDER BY
   region,
   name;
```

## 9. GNP が 150%以上アップしている国 (2025ver)

```sql
+---------------------------------------+---------+---------+------------+
| Name                                  | GNP     | GNPOld  | Percentage |
+---------------------------------------+---------+---------+------------+
| Congo, The Democratic Republic of the | 6964.00 | 2474.00 | 281.487500 |
| Turkmenistan                          | 4397.00 | 2000.00 | 219.850000 |
| Tajikistan                            | 1990.00 | 1056.00 | 188.447000 |
| Estonia                               | 5328.00 | 3371.00 | 158.054000 |
+---------------------------------------+---------+---------+------------+
4 rows in set (0.003 sec)
```

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

```sh
+-------------+----------+------------+------------+
| CountryCode | Language | IsOfficial | Percentage |
+-------------+----------+------------+------------+
| BMU         | English  | T          |      100.0 |
| CUB         | Spanish  | T          |      100.0 |
| SLV         | Spanish  | T          |      100.0 |
| COL         | Spanish  | T          |       99.0 |
| IRL         | English  | T          |       98.4 |
| DOM         | Spanish  | T          |       98.0 |
| NIC         | Spanish  | T          |       97.6 |
| CRI         | Spanish  | T          |       97.5 |
| GBR         | English  | T          |       97.3 |
| HND         | Spanish  | T          |       97.2 |
| VEN         | Spanish  | T          |       96.9 |
| ARG         | Spanish  | T          |       96.8 |
| URY         | Spanish  | T          |       95.7 |
| ECU         | Spanish  | T          |       93.0 |
| MEX         | Spanish  | T          |       92.1 |
| CHN         | Chinese  | T          |       92.0 |
| CHL         | Spanish  | T          |       89.7 |
| GIB         | English  | T          |       88.9 |
| BOL         | Spanish  | T          |       87.7 |
| NZL         | English  | T          |       87.0 |
| USA         | English  | T          |       86.2 |
| VIR         | English  | T          |       81.7 |
| AUS         | English  | T          |       81.2 |
| PER         | Spanish  | T          |       79.8 |
| SGP         | Chinese  | T          |       77.1 |
| PAN         | Spanish  | T          |       76.8 |
| ESP         | Spanish  | T          |       74.4 |
| GTM         | Spanish  | T          |       64.7 |
| CAN         | English  | T          |       60.4 |
| PRY         | Spanish  | T          |       55.1 |
| PRI         | Spanish  | T          |       51.3 |
| BLZ         | English  | T          |       50.8 |
| GUM         | English  | T          |       37.5 |
| VUT         | English  | T          |       28.3 |
| LCA         | English  | T          |       20.0 |
| ZAF         | English  | T          |        8.5 |
| NRU         | English  | T          |        7.5 |
| MNP         | English  | T          |        4.8 |
| SYC         | English  | T          |        3.8 |
| PLW         | English  | T          |        3.2 |
| ASM         | English  | T          |        3.1 |
| HKG         | English  | T          |        2.2 |
| ZWE         | English  | T          |        2.2 |
| MLT         | English  | T          |        2.1 |
| WSM         | English  | T          |        0.6 |
+-------------+----------+------------+------------+
45 rows in set (0.004 sec)
```

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
