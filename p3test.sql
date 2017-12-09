CONNECT to CS157a;

-- create customer
CALL P3.CUST_CRT('Bob', 'M', 20, 1111, ?,?,?);
CALL P3.CUST_CRT('Sarah', 'F', 25, 2222, ?,?,?);
CALL P3.CUST_CRT('Chris', 'M', 40, 3333, ?,?,?);
CALL P3.CUST_CRT('Powell', 'M', 20, 1234, ?,?,?);
CALL P3.CUST_CRT('Bebe', 'F', 25, 4321, ?,?,?);
CALL P3.CUST_CRT('Annie', 'F', 40, 1414, ?,?,?);


-- customer login
CALL P3.CUST_LOGIN(100, 1111, ?,?,?);
CALL P3.CUST_LOGIN(101, 2222, ?,?,?);

CALL P3.CUST_LOGIN(102, 2222, ?,?,?);
CALL P3.CUST_LOGIN(99, 2222, ?,?,?);

-- open account
CALL P3.ACCT_OPN(100, 100, 'C',?,?,?);
CALL P3.ACCT_OPN(100, 200, 'S',?,?,?);
CALL P3.ACCT_OPN(101, 300, 'C',?,?,?);
CALL P3.ACCT_OPN(101, 400, 'S',?,?,?);
CALL P3.ACCT_OPN(102, 500, 'C',?,?,?);
CALL P3.ACCT_OPN(102, 600, 'S',?,?,?);
CALL P3.ACCT_OPN(103, 700, 'C',?,?,?);
CALL P3.ACCT_OPN(103, 800, 'S',?,?,?);
CALL P3.ACCT_OPN(104, 900, 'C',?,?,?);
CALL P3.ACCT_OPN(104, 1000, 'S',?,?,?);
CALL P3.ACCT_OPN(105, 1100, 'C',?,?,?);
CALL P3.ACCT_OPN(105, 1200, 'S',?,?,?);

CALL P3.ACCT_OPN(105, -1, 'C',?,?,?);
CALL P3.ACCT_OPN(99, 1200, 'S',?,?,?);

-- close account
CALL P3.ACCT_CLS(1003, ?,?);
CALL P3.ACCT_CLS(1004, ?,?);

CALL P3.ACCT_CLS(999, ?,?);

--deposit into account
CALL P3.ACCT_DEP(1000, 33, ?,?);
-- deposit into invalid account
CALL P3.ACCT_DEP(9999, 44, ?,?);
--deposit with negative balance
CALL P3.ACCT_DEP(1001, -44, ?,?);
CALL P3.ACCT_DEP(1004, 99, ?,?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1001, 1004);

-- withdraw from account
CALL P3.ACCT_WTH(1000, 22, ?, ?);
-- over drawn
CALL P3.ACCT_WTH(1002, 2000, ?, ?);
CALL P3.ACCT_WTH(1003, -88, ?, ?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1002);

UPDATE p3.account set Balance = 100 where number = 1000;
UPDATE p3.account set Balance = 200 where number = 1001;
UPDATE p3.account set Balance = 300 where number = 1002;
UPDATE p3.account set Balance = 400 where number = 1003;

--transfeer to another account
CALL P3.ACCT_TRX(1003, 1002, 66, ?,?);
--deffernt customer
CALL P3.ACCT_TRX(1005, 1000, 99, ?,?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1002, 1003, 1005);

UPDATE p3.account set Balance = 100 where number = 1000;
UPDATE p3.account set Balance = 200 where number = 1001;
UPDATE p3.account set Balance = 300 where number = 1002;
UPDATE p3.account set Balance = 400 where number = 1003;
UPDATE p3.account set Balance = 500 where number = 1004;
UPDATE p3.account set Balance = 600 where number = 1005;

--interest
SELECT NUMBER, BALANCE FROM p3.account;
CALL P3.ADD_INTEREST (0.5, 0.1,?,?);
SELECT NUMBER, BALANCE FROM p3.account;
