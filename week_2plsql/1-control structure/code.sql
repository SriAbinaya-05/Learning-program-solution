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

-- STEP 3: Insert Sample Data
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

-- Loan due in 15 days (within next 30 days)
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (1, 1, 5000, 5, SYSDATE, SYSDATE + 15);

-- Loan due after 45 days (not shown in reminder)
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (2, 2, 3000, 6, SYSDATE, SYSDATE + 45);

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15', 'YYYY-MM-DD'));
-- STEP 4: Add IsVIP Column
ALTER TABLE Customers ADD IsVIP VARCHAR2(5);

-- STEP 5: Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- STEP 6: PL/SQL BLOCK
DECLARE
    v_age NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 1: Apply Interest Discount ---');
    FOR cust1 IN (SELECT CustomerID, DOB FROM Customers) LOOP
        v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, cust1.DOB) / 12);
        IF v_age > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE CustomerID = cust1.CustomerID;
            DBMS_OUTPUT.PUT_LINE('Applied 1% discount for Customer ID: ' || cust1.CustomerID);
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Scenario 2: Set VIP Status ---');
    FOR cust2 IN (SELECT CustomerID, Balance FROM Customers) LOOP
        IF cust2.Balance > 10000 THEN
            UPDATE Customers SET IsVIP = 'TRUE' WHERE CustomerID = cust2.CustomerID;
            DBMS_OUTPUT.PUT_LINE('VIP status granted to Customer ID: ' || cust2.CustomerID);
        ELSE
            UPDATE Customers SET IsVIP = 'FALSE' WHERE CustomerID = cust2.CustomerID;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Scenario 3: Loan Reminders ---');
    FOR loan_rec IN (
        SELECT L.LoanID, C.Name, L.EndDate
        FROM Loans L
        JOIN Customers C ON L.CustomerID = C.CustomerID
        WHERE L.EndDate BETWEEN SYSDATE AND SYSDATE + 30
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan_rec.LoanID ||
                             ' for Customer ' || loan_rec.Name ||
                             ' is due on ' || loan_rec.EndDate);
    END LOOP;
END;
