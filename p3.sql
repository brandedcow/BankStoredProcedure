CREATE OR REPLACE PROCEDURE P3.CUST_CRT (
	IN name VARCHAR(15),
	IN gender CHAR,
	IN age INTEGER,
	IN pin INTEGER,
	OUT cust_id INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

  	IF age < 0 THEN
  		SET err_msg = 'Age cannot be negative';
  		RETURN -1;
  	END IF;

  	IF pin < 0 THEN
  		SET err_msg = 'Pin cannot be negative';
  		RETURN -1;
  	END IF;

  	If pin < 999 THEN
  		SET err_msg = 'Pin must be more than 4 digits';
  		RETURN -1;
  	END IF;

	SELECT ID INTO cust_id FROM FINAL TABLE(
  		INSERT INTO P3.CUSTOMER (NAME, GENDER, AGE, PIN) VALUES (name,gender,age,pin)
  	);
  	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.CUST_LOGIN (
	IN cus_id INTEGER,
	IN cus_pin INTEGER,
	OUT valid INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
	DECLARE tempname varchar(15);
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

	SELECT NAME INTO tempname FROM P3.CUSTOMER WHERE (ID=cus_id AND PIN=cus_pin);

	IF SQLCODE = 0 THEN
		SET valid = 1;
	ELSE
		SET valid = 0;
	END IF;
	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ACCT_OPN (
	IN cus_id INTEGER,
	IN ini_balance INTEGER,
	IN acc_type CHAR,
	OUT acc_id INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
	DECLARE tempaccid INTEGER;
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

  	IF ini_balance < 0 THEN
  		SET err_msg = 'Initial deposit cannot be negative';
  		RETURN -1;
  	END IF;

	SELECT NUMBER INTO tempaccid FROM FINAL TABLE
       (INSERT INTO P3.ACCOUNT (ID, BALANCE, TYPE, STATUS) VALUES (cus_id, ini_balance, acc_type, 'A'));

	IF SQLCODE = 0 THEN
		SET acc_id = tempaccid;
	END IF;
	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ACCT_CLS (
	IN acc_id INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

	UPDATE P3.ACCOUNT SET BALANCE=0, STATUS='I' WHERE (NUMBER=acc_id);

	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ACCT_DEP (
	IN acc_id INTEGER,
	IN dep_amt INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

  	IF dep_amt < 0 THEN
  		SET err_msg = 'Deposit amount cannot be negative';
  		RETURN -1;
  	END IF;

	UPDATE P3.ACCOUNT SET BALANCE=BALANCE+dep_amt WHERE (NUMBER=acc_id AND STATUS='A');

	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ACCT_WTH (
	IN acc_id INTEGER,
	IN wth_amt INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

  	IF wth_amt < 0 THEN
  		SET err_msg = 'Withdraw ammount cannot be negative';
  		RETURN -1;
  	END IF;

	UPDATE P3.ACCOUNT SET BALANCE=BALANCE-wth_amt WHERE (NUMBER=acc_id AND STATUS='A');

	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ACCT_TRX (
	IN src_acc_id INTEGER,
	IN dest_acc_id INTEGER,
	IN trx_amt INTEGER,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

   	IF trx_amt < 0 THEN
  		SET err_msg = 'Transfer amount cannot be negative';
  		RETURN -1;
  	END IF;

	CALL P3.ACCT_WTH(src_acc_id, trx_amt, retcode, err_msg);

	IF SQLCODE = 0 THEN
		CALL P3.ACCT_DEP(dest_acc_id, trx_amt, retcode, err_msg);
	END IF;

	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END

CREATE OR REPLACE PROCEDURE P3.ADD_INTEREST (
	IN savings_rate FLOAT,
	IN checking_rate FLOAT,
	OUT retcode INTEGER,
	OUT err_msg varchar(255)
) BEGIN
  	DECLARE SQLCODE INTEGER DEFAULT 0;
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  		SET retcode = SQLCODE;

   	IF savings_rate < 0 THEN
  		SET err_msg = 'Interest rates cannot be negative';
  		RETURN -1;
  	END IF;
  	IF savings_rate > 1 THEN
  		SET err_msg = 'Interest rates cannot be greater than 100%';
  		RETURN -1;
  	END IF;

   	IF checking_rate < 0 THEN
  		SET err_msg = 'Interest rates cannot be negative';
  		RETURN -1;
  	END IF;
    IF checking_rate > 1 THEN
  		SET err_msg = 'Interest rates cannot be greater than 100%';
  		RETURN -1;
  	END IF;

	UPDATE P3.ACCOUNT SET BALANCE=BALANCE*(1+savings_rate) WHERE (TYPE='S' AND STATUS='A');
	UPDATE P3.ACCOUNT SET BALANCE=BALANCE*(1+checking_rate) WHERE (TYPE='C' AND STATUS='A');

	IF SQLCODE < 0 THEN
		SET err_msg='Exception Error';
	END IF;
END
