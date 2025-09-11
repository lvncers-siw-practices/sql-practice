DROP TABLE IF EXISTS bank_accounts;

CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    name VARCHAR(50),
    balance INT
) ENGINE=InnoDB;

INSERT INTO bank_accounts VALUES
(1, '山田太郎', 100000),
(2, '佐藤花子', 50000);

DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(50),
    stock INT
) ENGINE=InnoDB;

INSERT INTO inventory VALUES
(1, 'ノートPC', 5),
(2, 'マウス', 10);
