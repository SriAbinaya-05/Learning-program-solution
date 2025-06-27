CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DOB DATE,
    Balance NUMBER,
    LastModified DATE
);

CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountType VARCHAR2(20),
    Balance NUMBER,
    LastModified DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER,
    TransactionDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    LoanAmount NUMBER,
    InterestRate NUMBER,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Position VARCHAR2(50),
    Salary NUMBER,
    Department VARCHAR2(50),
    HireDate DATE
);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
VALUES (1, 'John Doe', TO_DATE('1950-05-15', 'YYYY-MM-DD'), 12000, SYSDATE);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
VALUES (2, 'Jane Smith', TO_DATE('1990-07-20', 'YYYY-MM-DD'), 1500, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (1, 1, 'Savings', 1000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (2, 2, 'Checking', 1500, SYSDATE);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (1, 1, SYSDATE, 200, 'Deposit');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

--scenerio 1-Monthly interest

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
    UPDATE Accounts
    SET Balance = Balance * 1.01,
        LastModified = SYSDATE
    WHERE AccountType = 'Savings';

    DBMS_OUTPUT.PUT_LINE('Interest applied to ' || SQL%ROWCOUNT || ' savings account(s).');

    COMMIT;
END;
/

--scenerio2: UpdateEmployeeBonus
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_Department IN VARCHAR2,
    p_BonusPercent IN NUMBER
) IS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * p_BonusPercent / 100)
    WHERE Department = p_Department;

    DBMS_OUTPUT.PUT_LINE('Bonus applied to ' || SQL%ROWCOUNT || ' employee(s) in ' || p_Department || ' department.');

    COMMIT;
END;
/
--scenerio3-Transfer Funds
CREATE OR REPLACE PROCEDURE TransferFunds(
    p_SourceAccountID IN NUMBER,
    p_TargetAccountID IN NUMBER,
    p_Amount IN NUMBER
) IS
    v_SourceBalance NUMBER;
BEGIN
    SELECT Balance INTO v_SourceBalance
    FROM Accounts
    WHERE AccountID = p_SourceAccountID
    FOR UPDATE;

    IF v_SourceBalance < p_Amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
    END IF;

    UPDATE Accounts
    SET Balance = Balance - p_Amount,
        LastModified = SYSDATE
    WHERE AccountID = p_SourceAccountID;

    UPDATE Accounts
    SET Balance = Balance + p_Amount,
        LastModified = SYSDATE
    WHERE AccountID = p_TargetAccountID;

    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (Transactions_seq.NEXTVAL, p_SourceAccountID, SYSDATE, p_Amount, 'Debit');

    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (Transactions_seq.NEXTVAL, p_TargetAccountID, SYSDATE, p_Amount, 'Credit');
END;
/
DBMS_OUTPUT.PUT_LINE('Transfer of ' || p_Amount || ' from Account ' || p_SourceAccountID || ' to Account ' || p_TargetAccountID);

    COMMIT;
END;
/
BEGIN
    ProcessMonthlyInterest;
END;
/
BEGIN
    UpdateEmployeeBonus('IT', 10);
END;
/
BEGIN
    TransferFunds(1, 2, 200);
END;
/
