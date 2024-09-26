CREATE DATABASE Crypto_staking;
-- table 1 (user)
create table User (UserId int auto_increment primary key  , Username varchar(20) not null , Password varchar(20), Email varchar (20) unique  , Created_at datetime , 
Verified_at boolean , Status Boolean , Role varchar(30), Referralcode varchar(50) unique  ,Refer_by int ,foreign key(Refer_by) references User(UserId) ) ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
insert Into wallet(User_id) values (new.UserId);
END$$
DELIMITER ;

-- table 2 (wallet)
create table Wallet (Id int auto_increment primary key ,User_id int , foreign key (User_id) references User(UserId) on update cascade on delete cascade, Available_Balance float , Reserved_Balance float , 
Level_Income float , Referral_Income float , Reward_Income float , ROI_Income float , Status varchar(20));

-- table 3 (packages)
create table Packages (Id int auto_increment primary key ,Package_name varchar(30) unique   ,Amount float , Period datetime , ROI_per_day float , Status boolean);

--  table 4 (user membership)
create table User_Membership (Id int auto_increment primary key , UserId int , foreign key (UserId) references User(UserId) on update cascade on delete cascade, 
PackageId int ,foreign key (PackageId) references Packages(Id) on update cascade on delete cascade, Created_at datetime , Status boolean, ROI_Recevied_date datetime, Next_date datetime);

-- table 5 (ROI income ) 
create table ROI_Income (Id int auto_increment primary key , foreign key (Id) references User_Membership(Id) on update cascade on delete cascade,Date_time datetime , 
ROI_Received float);

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `roi_income_AFTER_INSERT` AFTER INSERT ON `roi_income` FOR EACH ROW BEGIN
insert into Wallet(ROI_Income) 
Values (new.ROI_Received);
END$$
DELIMITER ;

-- table 6 (userreferral)
create table UserReferral (Id int auto_increment primary key , ChildId int , foreign key (ChildId) references User(UserId) on update cascade on delete cascade, 
ParentId int , foreign key (ParentId) references User(UserId) on update cascade on delete cascade, Date_time datetime , Referral_income int);
DELIMITER $$

CREATE DEFINER=`root`@`localhost` TRIGGER `userreferral_AFTER_INSERT` AFTER INSERT ON `userreferral` FOR EACH ROW BEGIN
insert into Wallet(Referral_Income) 
Values (new.Referral_income);
END$$
DELIMITER ;

-- table 10 (levels)
create table Levels (Id int auto_increment  primary key , Points decimal(10,2));

-- table 7 (levelincome)
create table LevelIncome (Id int primary key , ChildId int ,  foreign key (ChildId) references User(UserId) on update cascade on delete cascade, 
ParentId int , foreign key (ParentId) references User(UserId) on update cascade on delete cascade, Date datetime , Level_Income_Rec varchar(30), 
Level_Id int , foreign key (Level_Id) references Levels(Id) on update cascade on delete cascade);
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `levelincome_AFTER_INSERT` AFTER INSERT ON `levelincome` FOR EACH ROW BEGIN
insert into Wallet(Level_Income) 
Values (new.Level_Income_Rec);
END$$
DELIMITER ;

-- table 8 (reward)
create table Reward (Id int auto_increment primary key , Reward_name varchar(50), Reward varchar(50), Business_required varchar(50) , Status boolean);

-- table 9 (user reward )
create table User_Reward (Id int auto_increment primary key , UserId int , foreign key (UserId) references User(UserId) on update cascade on delete cascade, 
RewardId int , foreign key (RewardId) references Reward(Id) on update cascade on delete cascade,Date datetime , Reward_rec varchar(30));
DELIMITER $$

CREATE DEFINER=`root`@`localhost` TRIGGER `user_reward_AFTER_INSERT` AFTER INSERT ON `user_reward` FOR EACH ROW BEGIN
insert into Wallet(Reward_Income) 
Values (new.Reward_rec);
END$$
DELIMITER ;

-- table 11 (ledger)
create table Ledger (Id int auto_increment primary key , Wallet_Id int , foreign key (Wallet_Id) references Wallet(Id) on update cascade on delete cascade,
Opening_balance float , Closing_balance float , Credit float , Debit float , Type_income varchar(30), Date_time datetime , Status boolean , Amount float , Comment varchar(30));
