-- CREATE TABLES
-- Table 1: Statewise Table
CREATE TABLE statewise (
	"state" VARCHAR PRIMARY KEY,	
	"literacy_rate(%)" DECIMAL,
	"numeracy_rate(%)" DECIMAL,
	"illiteracy_rate(%)" DECIMAL,
	"pop_with_b_degree(%)" INT,
	bank_branches_in_2023 INT,
	branches_per_100000_residents DECIMAL,
	"employment_rate(%)" DECIMAL,
	civilian_labour_force INT,
	unemployed_population DECIMAL,
	"children_0_to_18(%)" DECIMAL,
	"adults_19_to_25(%)" DECIMAL,
	"adults_26_to_34(%)" DECIMAL,
	"adults_35_to_54(%)" DECIMAL, 
	"adults_55_to_64(%)" DECIMAL,
	"65+(%)" DECIMAL
);

-- Table 2: Branch Table
CREATE TABLE branch (
	branch_id INT PRIMARY KEY,
	name VARCHAR(255),
	address VARCHAR(255),
	"state" VARCHAR(255),
	FOREIGN KEY (state) REFERENCES statewise(state)
);

--Table 3: Customer Table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    gender VARCHAR,
    date_of_birth DATE,
    branch_id INT,
	occupation VARCHAR,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- Table 4: Card Table
CREATE TABLE Card (
    card_id INT PRIMARY KEY,
	expiration_date DATE,
    card_number VARCHAR(16), -- Assuming a 16-digit card number
    is_blocked VARCHAR 
);

-- Table 5: Account Table
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
	bank_balance DECIMAL(10, 2),
    customer_id INT,
    card_id INT,
	acc_start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (card_id) REFERENCES card(card_id)
);

--Table 6: Transaction Table
CREATE TABLE Transaction (
    transaction_id INT PRIMARY KEY,
	date DATE,
    account_id INT,
    description VARCHAR,
    transaction_amount DECIMAL(10, 2), -- To allow for two decimal places for cents
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

-- Table 7: Loan Type Table
CREATE TABLE Loan_Type (
    loan_type_id INT PRIMARY KEY,
    loan_type VARCHAR(255),
    loan_type_description TEXT,
    base_amount DECIMAL(10, 2),
    base_interest_rate DECIMAL(5, 2) -- Assuming a max rate of 99.99%
);

--Table 8: Loan Table
CREATE TABLE Loan (
    loan_id INT PRIMARY KEY,
    account_id INT,
    loan_type_id INT,
    due_date DATE,
    start_date DATE,
    amount_paid DECIMAL(10, 2),
    FOREIGN KEY (account_id) REFERENCES account(account_id),
    FOREIGN KEY (loan_type_id) REFERENCES loan_type(loan_type_id)
);







