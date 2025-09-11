# ER 図 (Mermaid)

```mermaid
erDiagram
    会員 ||--o{ 注文 : ""
    注文 ||--|{ 注文明細 : ""
    商品 ||--o{ 注文明細 : ""
```
