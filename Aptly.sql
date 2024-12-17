--tables--------
DROP TABLE UserInfo;
DROP TABLE Property_Details;
DROP TABLE LocationInfo;
DROP TABLE Listing;
DROP TABLE Review;
DROP TABLE Favorites;
DROP TABLE Neighborhood;
DROP TABLE Export_Action;
DROP TABLE csvExport;
DROP TABLE pdfExport;
DROP TABLE xlsxExport;
DROP TABLE Tour;
DROP TABLE Scheduled;
DROP TABLE Unscheduled;
DROP TABLE Completed;
DROP TABLE History;
DROP TABLE PriceUpdate;
DROP TABLE AvailabilityUpdate;
DROP TABLE DescriptionUpdate;
DROP TABLE passwordHistory;

---------sequences-------------------
DROP SEQUENCE user_seq;
DROP SEQUENCE property_seq;
DROP SEQUENCE location_seq;
DROP SEQUENCE listing_seq;
DROP SEQUENCE review_seq;
DROP SEQUENCE favorites_seq;
DROP SEQUENCE neighborhood_seq;
DROP SEQUENCE export_seq;
DROP SEQUENCE tour_seq;
DROP SEQUENCE history_seq;
DROP SEQUENCE password_seq;

---------procedures-------------------
DROP PROCEDURE AddAccount;
DROP PROCEDURE AddPropertyDetails;

---------foreign key indexes-------------------
DROP INDEX ListingUserIdx ON Listing;
DROP INDEX ListingPropertyIdx ON Listing;
DROP INDEX ListingLocationIdx ON Listing;
DROP INDEX ReviewUserIdx ON Review;
DROP INDEX ReviewListingIdx ON Review;
DROP INDEX Export_ActionUserIdx ON Export_Action;
DROP INDEX Export_ActionListingIdx ON Export_Action;
DROP INDEX FavoritesUserIdx ON Favorites;
DROP INDEX FavoritesListingIdx ON Favorites;
DROP INDEX TourListingIdx ON Tour;
DROP INDEX HistoryListingIdx ON History;
DROP INDEX NeighborhoodListingIdx ON Neighborhood;

---------query-driven indexes-------------------
DROP INDEX ListingTitleIdx ON Listing;
DROP INDEX PropertyPriceIdx ON Property_Details;
DROP INDEX NeighborhoodNameIdx ON Neighborhood;

---------trigger-------------------
DROP TRIGGER passwordChangeTrigger;

---------VIEWS-------------------
DROP VIEW NeighborhoodSummary;
DROP VIEW NeighborhoodSummary2;

--TABLES
CREATE TABLE UserInfo(
    userID DECIMAL(12) NOT NULL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL, 
    last_name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_date DATE NOT NULL,
);

CREATE TABLE Property_Details(
    propertyID DECIMAL(12) NOT NULL PRIMARY KEY,
    number_of_beds DECIMAL(12) NOT NULL,
    number_of_baths DECIMAL(12) NOT NULL,
    property_description VARCHAR(255) NOT NULL,
    property_price DECIMAL(12) NOT NULL,
    available_on DATE NOT NULL, 
    listed_on DATE NOT NULL,
);

CREATE TABLE LocationInfo(
    locationID DECIMAL(12) NOT NULL PRIMARY KEY,
    street VARCHAR(255) NOT NULL, 
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
);

CREATE TABLE Listing(
    listingID DECIMAL(12) NOT NULL PRIMARY KEY,
    userID DECIMAL(12) NOT NULL,
    propertyID DECIMAL(12) NOT NULL,
    locationID DECIMAL(12) NOT NULL,
    listing_title VARCHAR(255) NOT NULL,
    FOREIGN KEY(userID) REFERENCES UserInfo(userID),
    FOREIGN KEY(propertyID) REFERENCES Property_Details(propertyID),
    FOREIGN KEY(locationID) REFERENCES LocationInfo(locationID)
);

CREATE TABLE Review(
    reviewID DECIMAL(12) NOT NULL PRIMARY KEY,
    userID DECIMAL(12) NOT NULL,
    listingID DECIMAL(12) NOT NULL,
    rating DECIMAL(12) NOT NULL,
    review_comments VARCHAR(255),
    reviewed_on DATE NOT NULL,
    FOREIGN KEY(userID) REFERENCES UserInfo(userID),
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE Favorites(
    favoriteID DECIMAL(12) NOT NULL PRIMARY KEY,
    userID DECIMAL(12) NOT NULL,
    listingID DECIMAL(12) NOT NULL,
    favorited_on DATE NOT NULL,
    FOREIGN KEY(userID) REFERENCES UserInfo(userID),
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE Neighborhood(
    neighborhoodID DECIMAL(12) NOT NULL PRIMARY KEY,
    listingID DECIMAL(12) NOT NULL,
    neighborhood_name VARCHAR(255) NOT NULL,
    neighborhood_description VARCHAR(255) NOT NULL,
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE Export_Action(
    exportID DECIMAL(12) NOT NULL PRIMARY KEY,
    userID DECIMAL(12) NOT NULL,
    listingID DECIMAL(12) NOT NULL,
    files_format VARCHAR(10) NOT NULL CHECK (files_format IN ('CSV', 'PDF', 'Xlsx')),
    file_name VARCHAR(255) NOT NULL,
    exported_on DATE NOT NULL,
    FOREIGN KEY(userID) REFERENCES UserInfo(userID),
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE csvExport(
    exportID DECIMAL(12) NOT NULL PRIMARY KEY,
    delimited_type VARCHAR(255) NOT NULL,
    FOREIGN KEY(exportID) REFERENCES Export_Action(exportID)
);

CREATE TABLE pdfExport(
    exportID DECIMAL(12) NOT NULL PRIMARY KEY,
    page_size VARCHAR(255) NOT NULL,
    orientation VARCHAR(255),
    FOREIGN KEY(exportID) REFERENCES Export_Action(exportID)
);

CREATE TABLE xlsxExport(
    exportID DECIMAL(12) NOT NULL PRIMARY KEY,
    sheet_name VARCHAR(255),
    FOREIGN KEY(exportID) REFERENCES Export_Action(exportID)
);

CREATE TABLE Tour(
    tourID DECIMAL(12) NOT NULL PRIMARY KEY,
    listingID DECIMAL(12) NOT NULL,
    tour_type VARCHAR(64) NOT NULL CHECK (tour_type IN ('Scheduled', 'Unscheduled', 'Completed')),
    tour_feedback VARCHAR(255),
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE Scheduled(
    tourID DECIMAL(12) NOT NULL PRIMARY KEY,
    scheduled_on DATE NOT NULL,
    time_slot TIME NOT NULL,
    FOREIGN KEY(tourID) REFERENCES Tour(tourID)
);

CREATE TABLE Unscheduled(
    tourID DECIMAL(12) NOT NULL PRIMARY KEY,
    requested_date DATE NOT NULL,
    priority VARCHAR(255),
    FOREIGN KEY(tourID) REFERENCES Tour(tourID)
);

CREATE TABLE Completed(
    tourID DECIMAL(12) NOT NULL PRIMARY KEY,
    completion_date DATE NOT NULL,
    tour_feedback VARCHAR(255),
    FOREIGN KEY(tourID) REFERENCES Tour(tourID)
);

CREATE TABLE History(
    historyID DECIMAL(12) NOT NULL PRIMARY KEY,
    listingID DECIMAL(12) NOT NULL,
    update_type VARCHAR(255) NOT NULL CHECK (update_type IN ('Price Update', 'Availability Update', 'Description Update')),
    updated_on DATE NOT NULL,
    FOREIGN KEY(listingID) REFERENCES Listing(listingID)
);

CREATE TABLE PriceUpdate(
    historyID DECIMAL(12) NOT NULL PRIMARY KEY,
    old_price DECIMAL(12) NOT NULL,
    new_price DECIMAL(12) NOT NULL,
    FOREIGN KEY (historyID) REFERENCES History(historyID)
);

CREATE TABLE AvailabilityUpdate(
    historyID DECIMAL(12) NOT NULL PRIMARY KEY,
    old_availability_date DATE NOT NULL,
    new_availability_date DATE NOT NULL,
    FOREIGN KEY (historyID) REFERENCES History(historyID)
);

CREATE TABLE DescriptionUpdate(
    historyID DECIMAL(12) NOT NULL PRIMARY KEY,
    old_description VARCHAR(255) NOT NULL,
    new_description VARCHAR(255) NOT NULL,
    FOREIGN KEY (historyID) REFERENCES History(historyID)
);

--SEQUENCES
CREATE SEQUENCE user_seq START WITH 1;
CREATE SEQUENCE property_seq START WITH 1;
CREATE SEQUENCE location_seq START WITH 1;
CREATE SEQUENCE listing_seq START WITH 1;
CREATE SEQUENCE review_seq START WITH 1;
CREATE SEQUENCE favorites_seq START WITH 1;
CREATE SEQUENCE neighborhood_seq START WITH 1;
CREATE SEQUENCE export_seq START WITH 1;
CREATE SEQUENCE tour_seq START WITH 1;
CREATE SEQUENCE history_seq START WITH 1;

--STORED PROCEDURES
-------------------------Stored Procedure 1---------------------------------------------------
CREATE PROCEDURE AddAccount @userID DECIMAL(12), @first_name VARCHAR(255), @last_name VARCHAR(255),
@username VARCHAR(255), @email VARCHAR(255), @password VARCHAR(255)
AS 
BEGIN
    INSERT INTO UserInfo(userID, first_name, last_name, username, email, password, created_date)
    VALUES(@userID, @first_name,  @last_name, @username,@email, @password, GETDATE());
END;
GO

DECLARE @current_user_seq INT = NEXT VALUE FOR user_seq;
BEGIN TRANSACTION AddAccount;
EXECUTE AddAccount @current_user_seq, 'Ted', 'Mosby', 'ted_mosby', 'ted.mosby@gmail.com', 'tmosby';
COMMIT TRANSACTION AddAccount;

DECLARE @new_user_seq DECIMAL(12);
SET @new_user_seq = NEXT VALUE FOR user_seq;
EXEC AddAccount @new_user_seq, 'Robin', 'Scherbatsky', 'robin_s', 'robin.scherbatsky@gmail.com', 'rscherbs';

SELECT * FROM UserInfo;

-------------------------Stored Procedure 2--------------------------------------------------
CREATE PROCEDURE AddPropertyDetails @propertyID DECIMAL(12), @number_of_beds DECIMAL(12), @number_of_baths DECIMAL(12),
@property_description VARCHAR(255), @property_price DECIMAL(12), @available_on DATE
AS 
BEGIN
    INSERT INTO Property_Details(propertyID, number_of_beds, number_of_baths, property_description, property_price, available_on, listed_on)
    VALUES(@propertyID, @number_of_beds,  @number_of_baths, @property_description, @property_price, @available_on, GETDATE());
END;
GO

DECLARE @current_property_seq INT = NEXT VALUE FOR property_seq;
BEGIN TRANSACTION AddPropertyDetails;
EXECUTE AddPropertyDetails @current_property_seq, 2, 2, 'Spacious 2b2b with attached balcony and amazing view!', 1299, '1/1/2025';
COMMIT TRANSACTION AddPropertyDetails;

DECLARE @new_property_seq DECIMAL(12);
SET @new_property_seq = NEXT VALUE FOR property_seq;
EXEC AddPropertyDetails @new_property_seq, 3, 2, 'Modern 3b2b with smart appliances', 2500, '1/15/2025';

SELECT * FROM Property_Details;


--INSERTS

--Location Info Table
DECLARE @current_location_seq INT = NEXT VALUE FOR location_seq;
INSERT INTO LocationInfo(locationID, street, city, state, zipcode)
VALUES
    (@current_location_seq, '123 Elm St', 'Boston', 'MA', '02115'),
    (NEXT VALUE FOR location_seq, '456 Maple St', 'Cambridge', 'MA', '02139');

SELECT * FROM LocationInfo;

--Listing Table
DECLARE @current_listing_seq INT = NEXT VALUE FOR listing_seq;
INSERT INTO Listing(listingID, userID, propertyID, locationID, listing_title)
VALUES
    (@current_listing_seq, (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
    (SELECT propertyID FROM Property_Details WHERE property_description = 'Spacious 2b2b with attached balcony and amazing view!'), 
    (SELECT locationID FROM LocationInfo WHERE street='123 Elm St'), 'Beautiful 2B2B in Boston'),

    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
    (SELECT propertyID FROM Property_Details WHERE property_description = 'Modern 3b2b with smart appliances'), 
    (SELECT locationID FROM LocationInfo WHERE street='456 Maple St'), 'Spacious 3B2B in Cambridge');

SELECT * FROM Listing;

--Reviews Table
DECLARE @current_review_seq INT = NEXT VALUE FOR review_seq;
INSERT INTO Review (reviewID, userID, listingID, rating, review_comments, reviewed_on)
VALUES
    (@current_review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     5, 'Amazing apartment with great views!', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     4, 'Nice place but a bit pricey.', GETDATE());

SELECT * FROM Review;

--Favorites Table
DECLARE @current_favorites_seq INT = NEXT VALUE FOR favorites_seq;
INSERT INTO Favorites (favoriteID, userID, listingID, favorited_on)
VALUES
    (@current_favorites_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     GETDATE()),

    (NEXT VALUE FOR favorites_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     GETDATE());

SELECT * FROM Favorites;

-- Tour Table
DECLARE @current_tour_seq INT = NEXT VALUE FOR tour_seq;
INSERT INTO Tour (tourID, listingID, tour_type, tour_feedback)
VALUES
    (@current_tour_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     'Scheduled', 'Looking forward to seeing this apartment.'),

    (NEXT VALUE FOR tour_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     'Completed', 'Lovely apartment, already signed the lease.');

INSERT INTO Scheduled (tourID, scheduled_on, time_slot)
VALUES
    ((SELECT tourID FROM Tour WHERE tour_type = 'Scheduled' AND tour_feedback = 'Looking forward to seeing this apartment.'), 
     '2025-02-10', '10:00 AM');

INSERT INTO Unscheduled (tourID, requested_date, priority)
VALUES
    ((SELECT tourID FROM Tour WHERE tour_type = 'Unscheduled' AND tour_feedback = 'Lovely apartment, already signed the lease.'), 
     '2025-02-14', 'Medium');

INSERT INTO Completed (tourID, completion_date, tour_feedback)
VALUES
    ((SELECT tourID FROM Tour WHERE tour_type = 'Completed' AND tour_feedback = 'Lovely apartment, already signed the lease.'), 
     '2025-02-05', 'Great experience, would love to live there!');

SELECT * FROM Scheduled;
SELECT * FROM Unscheduled;
SELECT * FROM Completed;
SELECT * FROM Tour;

--History Table
DECLARE @current_history_seq  INT = NEXT VALUE FOR history_seq;
INSERT INTO History (historyID, listingID, update_type, updated_on)
VALUES
    (@current_history_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     'Price Update', GETDATE()),

    (NEXT VALUE FOR history_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     'Availability Update', GETDATE()),

    (NEXT VALUE FOR history_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     'Description Update', GETDATE());

SELECT * FROM History;

INSERT INTO PriceUpdate (historyID, old_price, new_price)
VALUES
    ((SELECT historyID FROM History 
      WHERE update_type = 'Price Update' 
        AND listingID = (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston')), 
     1299, 1399);

INSERT INTO AvailabilityUpdate(historyID, old_availability_date, new_availability_date)
VALUES
    ((SELECT historyID FROM History 
      WHERE update_type = 'Availability Update' 
        AND listingID = (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge')), 
     '2025-01-01', '2025-01-15');

INSERT INTO DescriptionUpdate (historyID, old_description, new_description)
VALUES
    ((SELECT historyID FROM History 
      WHERE update_type = 'Description Update' 
        AND listingID = (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge')), 
     'Modern 3b2b with smart appliances', 
     'Newly renovated 3b2b with modern appliances and upgraded balcony view!');

SELECT * FROM PriceUpdate;
SELECT * FROM AvailabilityUpdate;
SELECT * FROM DescriptionUpdate;

--Neigborhood Table
DECLARE @current_neighborhood_seq INT = NEXT VALUE FOR neighborhood_seq;
INSERT INTO Neighborhood (neighborhoodID, listingID, neighborhood_name, neighborhood_description)
VALUES
    (@current_neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     'Back Bay', 'Upscale area with historic charm and trendy shops.'),

    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     'Harvard Square', 'Bustling neighborhood with lots of cafes and bookstores.');

SELECT * FROM Neighborhood;

--Export Table
DECLARE @current_export_seq INT = NEXT VALUE FOR export_seq;
INSERT INTO Export_Action (exportID, userID, listingID, files_format, file_name, exported_on)
VALUES
    (@current_export_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Beautiful 2B2B in Boston'), 
     'CSV', 'beautiful_2b2b.csv', GETDATE()),

    (NEXT VALUE FOR export_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious 3B2B in Cambridge'), 
     'PDF', 'spacious_3b2b.pdf', GETDATE());

SELECT * FROM Export_Action;

INSERT INTO csvExport (exportID, delimited_type)
VALUES
    ((SELECT exportID FROM Export_Action WHERE files_format = 'CSV' AND file_name = 'beautiful_2b2b.csv'), 'Comma-separated');

INSERT INTO pdfExport (exportID, page_size, orientation)
VALUES
    ((SELECT exportID FROM Export_Action WHERE files_format = 'PDF' AND file_name = 'spacious_3b2b.pdf'), 'A4', 'Portrait');

INSERT INTO xlsxExport (exportID, sheet_name)
VALUES
    ((SELECT exportID FROM Export_Action WHERE files_format = 'Xlsx' AND file_name = 'example.xlsx'), 'Apartment Details');

SELECT * FROM csvExport;
SELECT * FROM pdfExport;
SELECT * FROM xlsxExport;

--QUERIES
-------------Query #1-----------------------------
SELECT CONCAT(u.first_name, ' ', u.last_name) AS 'Full Name',
li.listing_title AS 'Listing Title', 
CONCAT(p.number_of_beds, 'B', p.number_of_baths, 'B') AS 'Number of Beds & Baths',
CONCAT('$', p.property_price) AS 'Apartment Rent',
p.available_on AS 'Move-In Date',
CONCAT(lo.street, ', ', lo.city, ' ' , lo.state, ' ', lo.zipcode) AS 'Property Address',
r.rating AS 'Apartment Rating', r.review_comments AS 'User Notes'
FROM UserInfo u 
JOIN Listing li ON u.userID = li.userID
JOIN Property_Details p ON li.propertyID = p.propertyID
JOIN LocationInfo lo ON li.locationID = lo.locationID
JOIN Review r ON li.listingID = r.listingID;

-------------Query #2-----------------------------
SELECT CONCAT(lo.street, ', ', lo.city, ' ' , lo.state, ' ', lo.zipcode) AS 'Property Address',
       li.listing_title AS 'Listing Title', 
       CASE 
           WHEN a.historyID IS NOT NULL THEN CONCAT(a.old_availability_date, ' changed to ', a.new_availability_date)
           ELSE 'No availability update'
       END AS 'Updated Availability Date',
       CASE 
           WHEN d.historyID IS NOT NULL THEN CONCAT(d.old_description, ' changed to ', d.new_description)
           ELSE 'No description update'
       END AS 'Updated Description',
       h.updated_on AS 'Date Updated'
FROM History h 
LEFT JOIN AvailabilityUpdate a ON h.historyID = a.historyID
LEFT JOIN DescriptionUpdate d ON h.historyID = d.historyID
JOIN Listing li ON h.listingID = li.listingID
JOIN LocationInfo lo ON li.locationID = lo.locationID;

-------------Query #3(additional data has been added)-----------------------------
INSERT INTO UserInfo(userID, first_name, last_name, username, email, password, created_date)
VALUES
    (NEXT VALUE FOR user_seq, 'Marshall', 'Eriksen', 'marshall_e', 'marshall.eriksen@gmail.com', 'me123', GETDATE()),
    (NEXT VALUE FOR user_seq, 'Lily', 'Aldrin', 'lily_a', 'lily.aldrin@gmail.com', 'la123', GETDATE()),
    (NEXT VALUE FOR user_seq, 'Barney', 'Stinson', 'barney_s', 'barney.awesome@gmail.com', 'suits123', GETDATE());

INSERT INTO LocationInfo (locationID, street, city, state, zipcode)
VALUES
    (NEXT VALUE FOR location_seq, '789 Pine St', 'Boston', 'MA', '02130'),
    (NEXT VALUE FOR location_seq, '101 Walnut Ave', 'Cambridge', 'MA', '02139'),
    (NEXT VALUE FOR location_seq, '1 Legendary Ave', 'New York', 'NY', '10001');

INSERT INTO Property_Details (propertyID, number_of_beds, number_of_baths, property_description, property_price, available_on, listed_on)
VALUES
    (NEXT VALUE FOR property_seq, 3, 2, 'Spacious 3-bedroom apartment with park view', 2100, '2025-02-01', GETDATE()),
    (NEXT VALUE FOR property_seq, 1, 1, 'Modern studio apartment near downtown', 1500, '2025-01-10', GETDATE()),
    (NEXT VALUE FOR property_seq, 2, 2, 'Luxurious penthouse with city skyline views', 5000, '2025-03-01', GETDATE());

INSERT INTO Listing(listingID, userID, propertyID, locationID, listing_title)
VALUES
    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'marshall_e'), 
    (SELECT propertyID FROM Property_Details WHERE property_description = 'Spacious 3-bedroom apartment with park view'), 
    (SELECT locationID FROM LocationInfo WHERE street='789 Pine St'), 'Parkside 3B2B in Boston'),
    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'lily_a'), 
    (SELECT propertyID FROM Property_Details WHERE property_description ='Modern studio apartment near downtown'), 
    (SELECT locationID FROM LocationInfo WHERE street='101 Walnut Ave'), 'Studio in Cambridge near Downtown'),
    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'barney_s'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'Luxurious penthouse with city skyline views'), 
     (SELECT locationID FROM LocationInfo WHERE street = '1 Legendary Ave'), 
     'Legendary Penthouse in NYC');

INSERT INTO Neighborhood (neighborhoodID, listingID, neighborhood_name, neighborhood_description)
VALUES
    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Parkside 3B2B in Boston'), 
     'Back Bay', 
     'Upscale area with historic charm and trendy shops.'),
    (NEXT VALUE FOR neighborhood_seq, (SELECT listingID FROM Listing WHERE listing_title = 'Studio in Cambridge near Downtown'), 
     'Harvard Square', 'Bustling neighborhood with lots of cafes and bookstores.'),
    (NEXT VALUE FOR neighborhood_seq, (SELECT listingID FROM Listing WHERE listing_title = 'Legendary Penthouse in NYC'), 
     'Manhattan - Midtown', 
     'Bustling neighborhood with iconic attractions and upscale living.');

-------------Query #3(main query)-----------------------------
DROP VIEW NeighborhoodSummary;
CREATE VIEW NeighborhoodSummary AS 
SELECT 
    lo.city AS City,
    n.neighborhood_name AS NeighborhoodName,
    COUNT(DISTINCT li.listingID) AS TotalListings,
    AVG(p.property_price) AS AveragePrice
FROM Listing li
JOIN LocationInfo lo ON li.locationID = lo.locationID
JOIN Property_Details p ON li.propertyID = p.propertyID
JOIN Neighborhood n ON li.listingID = n.listingID
GROUP BY lo.city, n.neighborhood_name;

SELECT 
    City, 
    NeighborhoodName AS 'Neighborhood Name',
    TotalListings AS 'Total Number of Listings',
    CONCAT('$', FORMAT(AveragePrice, 'N2')) AS 'Average Rent'
FROM NeighborhoodSummary
ORDER BY TotalListings DESC;


--INDEXES
---------foreign key indexes-------------------
CREATE INDEX ListingUserIdx
ON Listing(userID);

CREATE INDEX ListingPropertyIdx
ON Listing(propertyID);

CREATE INDEX ListingLocationIdx
ON Listing(locationID);

CREATE INDEX ReviewUserIdx
ON Review(userID);

CREATE INDEX ReviewListingIdx
ON Review(listingID);

CREATE INDEX Export_ActionUserIdx
ON Export_Action(userID);

CREATE INDEX Export_ActionListingIdx
ON Export_Action(listingID);

CREATE INDEX FavoritesUserIdx
ON Favorites(userID);

CREATE INDEX FavoritesListingIdx
ON Favorites(listingID);

CREATE INDEX TourListingIdx
ON Tour(listingID);

CREATE INDEX HistoryListingIdx
ON History(listingID);

CREATE INDEX NeighborhoodListingIdx
ON Neighborhood(listingID);

---------query-driven indexes-------------------
CREATE INDEX ListingTitleIdx
ON Listing(listing_title);

CREATE INDEX PropertyPriceIdx
ON Property_Details(property_price);

CREATE INDEX NeighborhoodNameIdx
ON Neighborhood(neighborhood_name);


--History Table & Trigger
CREATE TABLE passwordHistory(
    passwordID DECIMAL(12) NOT NULL PRIMARY KEY,
    userID DECIMAL(12) NOT NULL,
    old_password VARCHAR(255) NOT NULL, 
    new_password VARCHAR(255) NOT NULL, 
    changed_on DATE NOT NULL,
    FOREIGN KEY(userID) REFERENCES UserInfo(userID),
);

CREATE SEQUENCE password_seq START WITH 1;

CREATE OR ALTER Trigger passwordChangeTrigger
ON UserInfo
AFTER UPDATE
AS BEGIN 
    DECLARE @old_password VARCHAR(255) = (SELECT password FROM DELETED)
    DECLARE @new_password VARCHAR(255) = (SELECT password FROM INSERTED)

    IF (@old_password <> @new_password)
    INSERT INTO passwordHistory(passwordID, userID, old_password, new_password, changed_on)
    VALUES(NEXT VALUE FOR password_seq, (SELECT userID FROM INSERTED), @old_password, @new_password, GETDATE());
END;

UPDATE UserInfo
SET password = 'tmosby_nyc'
WHERE userID = 1;

UPDATE UserInfo
SET password = 'tmosby_nyc_123'
WHERE userID = 1;

SELECT * FROM passwordHistory;


-- Visualization 1: Bar Chart -----

INSERT INTO LocationInfo (locationID, street, city, state, zipcode)
VALUES
    (NEXT VALUE FOR location_seq, '789 Boylston St', 'Boston', 'MA', '02116'),
    (NEXT VALUE FOR location_seq, '456 Beacon St', 'Cambridge', 'MA', '02138'),
    (NEXT VALUE FOR location_seq, '123 Broadway', 'New York', 'NY', '10007'),
    (NEXT VALUE FOR location_seq, '789 Madison Ave', 'New York', 'NY', '10065'),
    (NEXT VALUE FOR location_seq, '456 Park Ave', 'Brooklyn', 'NY', '11201'),
    (NEXT VALUE FOR location_seq, '101 Queens Blvd', 'Queens', 'NY', '11375');


INSERT INTO Property_Details (propertyID, number_of_beds, number_of_baths, property_description, property_price, available_on, listed_on)
VALUES
    (NEXT VALUE FOR property_seq, 2, 1, 'Cozy 2-bedroom unit with a shared backyard', 1800, '2025-02-15', GETDATE()),
    (NEXT VALUE FOR property_seq, 4, 3, 'Spacious family home with private garage and garden', 3200, '2025-01-25', GETDATE()),
    (NEXT VALUE FOR property_seq, 1, 1, 'Compact 1-bedroom apartment close to public transit', 1400, '2025-01-05', GETDATE()),
    (NEXT VALUE FOR property_seq, 3, 2, 'High-rise condo with gym access and rooftop pool', 2500, '2025-03-15', GETDATE()),
    (NEXT VALUE FOR property_seq, 5, 4, 'Large suburban house with basement and three-car garage', 4500, '2025-04-01', GETDATE());

INSERT INTO Listing (listingID, userID, propertyID, locationID, listing_title)
VALUES
    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'Cozy 2-bedroom unit with a shared backyard'), 
     (SELECT locationID FROM LocationInfo WHERE street='789 Boylston St'), 'Sunny 2B2B near Boston Common'),

    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'lily_a'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'Spacious family home with private garage and garden'), 
     (SELECT locationID FROM LocationInfo WHERE street='456 Beacon St'), 'Elegant Family Home in Cambridge'),

    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'barney_s'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'Compact 1-bedroom apartment close to public transit'), 
     (SELECT locationID FROM LocationInfo WHERE street = '123 Broadway'), 'Modern 1B1B in Manhattan'),

    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'High-rise condo with gym access and rooftop pool'), 
     (SELECT locationID FROM LocationInfo WHERE street = '789 Madison Ave'), 'Luxury Condo with Skyline Views'),

    (NEXT VALUE FOR listing_seq, (SELECT userID FROM UserInfo WHERE username = 'marshall_e'), 
     (SELECT propertyID FROM Property_Details WHERE property_description = 'Large suburban house with basement and three-car garage'), 
     (SELECT locationID FROM LocationInfo WHERE street = '456 Park Ave'), 'Spacious Suburban Retreat');


INSERT INTO Neighborhood (neighborhoodID, listingID, neighborhood_name, neighborhood_description)
VALUES
    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Sunny 2B2B near Boston Common'), 
     'Back Bay', 
     'Upscale area with historic charm and trendy shops.'),

    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Elegant Family Home in Cambridge'), 
     'Harvard Square', 
     'Bustling neighborhood with lots of cafes and bookstores.'),

    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Modern 1B1B in Manhattan'), 
     'Manhattan - Midtown', 
     'Bustling neighborhood with iconic attractions and upscale living.'),

    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Luxury Condo with Skyline Views'), 
     'Upper East Side', 
     'Exclusive neighborhood with designer boutiques and fine dining.'),

    (NEXT VALUE FOR neighborhood_seq, 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious Suburban Retreat'), 
     'Newton', 
     'Quiet suburban area with excellent schools and spacious homes.');


CREATE VIEW NeighborhoodSummary2 AS 
SELECT 
    n.neighborhood_name AS NeighborhoodName,
    AVG(p.property_price) AS AverageRent
FROM Listing li
JOIN Property_Details p ON li.propertyID = p.propertyID
JOIN Neighborhood n ON li.listingID = n.listingID
GROUP BY n.neighborhood_name;

SELECT 
    NeighborhoodName AS 'Neighborhood Name',
    CONCAT('$', FORMAT(AverageRent, 'N2')) AS 'Average Rent'
FROM NeighborhoodSummary2
ORDER BY AverageRent DESC;



-- Visualization 2: Pie Chart -----

INSERT INTO Review (reviewID, userID, listingID, rating, review_comments, reviewed_on)
VALUES
    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'robin_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Sunny 2B2B near Boston Common'), 
     4, 'Great location, but a bit noisy at night.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'lily_a'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Elegant Family Home in Cambridge'), 
     5, 'Beautiful home with plenty of space for our family!', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'barney_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Modern 1B1B in Manhattan'), 
     3, 'Compact space, not ideal for long-term living.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Luxury Condo with Skyline Views'), 
     4, 'Amazing views, but a bit on the expensive side.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'marshall_e'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Spacious Suburban Retreat'), 
     5, 'Perfect home for a growing family, loved the extra garage space!', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'lily_a'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Sunny 2B2B near Boston Common'), 
     2, 'Very noisy at night.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'barney_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Sunny 2B2B near Boston Common'), 
     5, 'It is legendary!', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'ted_mosby'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Modern 1B1B in Manhattan'), 
     3, 'Not very ideal.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'marshall_e'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Luxury Condo with Skyline Views'), 
     3, 'I love this apartment.', GETDATE()),

    (NEXT VALUE FOR review_seq, 
     (SELECT userID FROM UserInfo WHERE username = 'barney_s'), 
     (SELECT listingID FROM Listing WHERE listing_title = 'Sunny 2B2B near Boston Common'), 
     2, 'It is ok.', GETDATE());


SELECT 
    CONCAT(lo.street, ', ', lo.city, ', ', lo.state, ' ', lo.zipcode) AS 'Full Address',
    COUNT(r.reviewID) AS NumberOfRatings
FROM Review r
JOIN Listing l ON r.listingID = l.listingID
JOIN LocationInfo lo ON l.locationID = lo.locationID
GROUP BY lo.street, lo.city, lo.state, lo.zipcode
ORDER BY NumberOfRatings DESC;



