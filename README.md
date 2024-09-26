This SQL script defines the schema for a **Crypto Staking** system database. The schema includes various tables, triggers, and relationships to manage users, wallets, packages, income, and rewards within a staking platform. Below is an explanation of each table and its purpose:

### 1. **Database Creation: `Crypto_staking`**
   - The database `Crypto_staking` is created to hold all the tables related to the system.

### 2. **Table: `User`**
   - **Purpose**: Stores user details like username, password, email, role, referral information, and status (active or inactive).
   - **Columns**:
     - `UserId`: Unique identifier for the user (Primary Key).
     - `Refer_by`: Tracks who referred the user (Foreign Key referencing `User(UserId)`).
   - **Trigger**: After a new user is created, a corresponding wallet is automatically generated.

### 3. **Table: `Wallet`**
   - **Purpose**: Manages the user's wallet, holding balances such as available balance, reserved balance, level income, referral income, etc.
   - **Columns**:
     - `User_id`: Links the wallet to a specific user (Foreign Key referencing `User(UserId)`).
     - `Available_Balance`, `Reserved_Balance`: Tracks the user's balance.

### 4. **Table: `Packages`**
   - **Purpose**: Contains details of various staking packages available to users.
   - **Columns**:
     - `Package_name`: Name of the staking package.
     - `Amount`: The amount required to stake.
     - `Period`: Duration of the package.
     - `ROI_per_day`: Return on Investment per day.

### 5. **Table: `User_Membership`**
   - **Purpose**: Links a user to a specific package they have subscribed to.
   - **Columns**:
     - `UserId`: The user who subscribed (Foreign Key referencing `User(UserId)`).
     - `PackageId`: The package chosen by the user (Foreign Key referencing `Packages(Id)`).
   - Tracks ROI received and the next date for the ROI.

### 6. **Table: `ROI_Income`**
   - **Purpose**: Tracks the ROI (Return on Investment) income received by a user based on their package.
   - **Trigger**: When a new ROI income record is inserted, it updates the `ROI_Income` column in the user's wallet.

### 7. **Table: `UserReferral`**
   - **Purpose**: Manages the referral relationships between users.
   - **Columns**:
     - `ChildId`: The referred user (Foreign Key referencing `User(UserId)`).
     - `ParentId`: The user who referred the `ChildId` (Foreign Key referencing `User(UserId)`).
     - Tracks the referral income generated.
   - **Trigger**: When a referral is made, it updates the `Referral_Income` column in the wallet.

### 8. **Table: `Levels`**
   - **Purpose**: Defines the different levels in the system, which can be used to calculate level income.
   - **Columns**:
     - `Points`: Points associated with each level, which could determine earnings or rewards.

### 9. **Table: `LevelIncome`**
   - **Purpose**: Tracks the level income a user receives based on referrals and system levels.
   - **Columns**:
     - `ChildId`: User who generates the level income (Foreign Key referencing `User(UserId)`).
     - `ParentId`: The user receiving the level income (Foreign Key referencing `User(UserId)`).
     - `Level_Id`: The level at which the income is earned (Foreign Key referencing `Levels(Id)`).
   - **Trigger**: Automatically updates the `Level_Income` in the wallet after insertion.

### 10. **Table: `Reward`**
   - **Purpose**: Defines different rewards that users can earn based on their staking and referral activities.
   - **Columns**:
     - `Reward_name`: Name of the reward.
     - `Business_required`: The criteria for earning the reward (e.g., staking volume, referral count).

### 11. **Table: `User_Reward`**
   - **Purpose**: Tracks the rewards earned by individual users.
   - **Columns**:
     - `UserId`: The user who received the reward (Foreign Key referencing `User(UserId)`).
     - `RewardId`: The specific reward earned (Foreign Key referencing `Reward(Id)`).
   - **Trigger**: After a reward is assigned, the corresponding amount is added to the `Reward_Income` in the user's wallet.

### 12. **Table: `Ledger`**
   - **Purpose**: Keeps a record of all wallet transactions for auditing purposes.
   - **Columns**:
     - `Wallet_Id`: Links to the wallet where the transaction occurred (Foreign Key referencing `Wallet(Id)`).
     - `Opening_balance`, `Closing_balance`: Tracks the balance before and after the transaction.
     - `Credit`, `Debit`: Specifies whether the transaction is a credit or debit.
     - `Type_income`: Specifies the type of income (ROI, referral, level, reward, etc.).
     - `Amount`: The actual amount transacted.

### Triggers:
- **user_AFTER_INSERT**: Automatically creates a wallet entry when a new user is inserted into the `User` table.
- **roi_income_AFTER_INSERT**: Adds the ROI income to the wallet after a record is inserted into `ROI_Income`.
- **userreferral_AFTER_INSERT**: Updates the referral income in the wallet when a referral is recorded.
- **levelincome_AFTER_INSERT**: Updates the level income in the wallet when level income is recorded.
- **user_reward_AFTER_INSERT**: Updates the reward income in the wallet when a user receives a reward.

### Summary:
This schema is designed for a **staking platform** where users can:
- Join and refer others.
- Subscribe to staking packages.
- Earn multiple income types (ROI, level, referral, rewards).
- Automatically update their wallets and ledger records through triggers.
This design supports cascading updates and deletions, ensuring data integrity across related tables.
