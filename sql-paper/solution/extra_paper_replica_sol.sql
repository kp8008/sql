--extra paper : Paper-1-replica:

-- Table: Members
CREATE TABLE Members (
MemberID INT PRIMARY KEY IDENTITY(1,1), -- PRIMARY KEY with auto-increment [cite: 4]
FullName VARCHAR(100),
Email VARCHAR(100) UNIQUE, -- UNIQUE constraint [cite: 6]
JoinDate DATE,
MembershipType VARCHAR(20)
);
-- Table: Books
CREATE TABLE Books (
BookID INT PRIMARY KEY IDENTITY(1,1), -- PRIMARY KEY with auto-increment [cite: 12]
Title VARCHAR(150),
Author VARCHAR(100),
Genre VARCHAR(50),
PublishedYear INT,
TotalCopies INT,
AvailableCopies INT
)
-- Table: BorrowRecords
CREATE TABLE BorrowRecords (
BorrowID INT PRIMARY KEY IDENTITY(1,1), -- PRIMARY KEY with auto-increment [cite: 22]
MemberID INT FOREIGN KEY REFERENCES Members(MemberID), -- FOREIGN KEY to Members[cite: 23]
BookID INT FOREIGN KEY REFERENCES Books(BookID), -- FOREIGN KEY to Books [cite: 24]
BorrowDate DATE,
ReturnDate DATE -- NULL if not yet returned [cite: 26]
);

-- Table: Fines
CREATE TABLE Fines (
FineID INT PRIMARY KEY IDENTITY(1,1), -- PRIMARY KEY with auto-increment [cite: 30]
BorrowID INT FOREIGN KEY REFERENCES BorrowRecords(BorrowID), -- FOREIGN KEY to BorrowRecords [cite: 31]
FineAmount DECIMAL(10,2),
PaidStatus VARCHAR(20) -- e.g., 'Unpaid', 'Paid'
);



---====================================================
-- Insert data into Members
INSERT INTO Members (FullName, Email, JoinDate, MembershipType) VALUES
('Alice Johnson', 'alice.j@example.com', '2024-01-15', 'Standard'), -- Joined 2024 (for Q36)
('Bob Smith', 'bob.s@example.com', '2023-11-20', 'Premium'),
('Charlie Brown', 'charlie.b@example.com', '2024-02-28', 'Standard'), -- Joined 2024 (for Q36)
('Diana Prince', 'diana.p@example.com', '2023-05-10', 'Standard'),
('Eve Adams', 'eve.a@example.com', '2024-10-01', 'Premium');

-- Insert data into Books
INSERT INTO Books (Title, Author, Genre, PublishedYear, TotalCopies, AvailableCopies) VALUES
('The Secret Garden', 'J.K. Rowling', 'Fantasy', 2001, 5, 2), -- Author for Q37, Available > 0
('A Brief History of Time', 'Stephen Hawking', 'Science', 1988, 3, 3), -- Available > 0
('1984', 'George Orwell', 'Dystopian', 1949, 1, 0), -- Zero available copies (for Q38)
('Fantastic Beasts', 'J.K. Rowling', 'Fantasy', 2016, 4, 4), -- Another book by same author (for Q37)
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 2, 2),
('Unborrowed Title', 'Unknown Author', 'Mystery', 2020, 1, 1); -- Never borrowed (for Q50)

-- Insert data into BorrowRecords
-- Note: MemberID and BookID are automatically assigned based on insertion order.
INSERT INTO BorrowRecords (MemberID, BookID, BorrowDate, ReturnDate) VALUES
(1, 1, '2024-10-15', '2024-10-25'), -- Alice borrowed The Secret Garden (Returned)
(2, 3, '2024-11-01', NULL), -- Bob borrowed 1984 (Not returned yet - for Q39)
(1, 2, '2024-11-10', '2024-11-15'), -- Alice borrowed A Brief History (Returned)
(3, 1, '2024-11-17', NULL), -- Charlie borrowed The Secret Garden (Not returned yet, recent - forQ48)
(4, 5, '2024-09-01', '2024-09-15'), -- Diana borrowed Gatsby
(1, 4, '2024-11-18', NULL); -- Alice borrowed Fantastic Beasts (More than one book borrowed -for Q49, Recent - for Q46)

-- Insert data into Fines
-- Fine for Bob's overdue book (BorrowID 2)
INSERT INTO Fines (BorrowID, FineAmount, PaidStatus) VALUES
(2, 5.50, 'Unpaid'), -- Unpaid fine (for Q44)
(1, 2.00, 'Paid'),
(3, 1.00, 'Unpaid'); -- Another unpaid fine (for Q44)


---=======================================================================
--1. Display all members who joined in the year 2024.
SELECT *
FROM Members
WHERE JoinDate >= '2024-01-01' and JoinDate <'2025-01-01';

--2. Show all books written by a specific author (e.g., "J.K. Rowling").
select *
from Books
where Author = 'J.K. Rowling'

--3. List all books that have zero available copies.
select *
from Books
where AvailableCopies = 0

--4. Find all borrow records where the book has not been returned yet (ReturnDate ISNULL).
select *
from BorrowRecords
where ReturnDate is null

--5. Show all members who have borrowed at least one book.
select m.fullname,count(b.BorrowID)
from Members m join BorrowRecords b
on m.MemberID=b.MemberID
group by m.FullName
having count(b.BorrowID)>=1
--or
SELECT *
FROM Members
WHERE MemberID IN (SELECT MemberID FROM BorrowRecords);

--6. List all books borrowed by a specific member (using MemberID).
SELECT *
FROM Books
WHERE BookID IN (SELECT BookID FROM BorrowRecords WHERE MemberID = 2);

--7. Count how many books are available in each genre.
select genre ,count(availablecopies) as genrebooks
from books
group by genre

--8. Show the total number of books borrowed (all records count).
select count(*) as totalborrowed
from BorrowRecords

--9. Display members who have unpaid fines.
select m.fullname,f.PaidStatus
from Fines f 
join BorrowRecords b on f.BorrowID= b.borrowid
join Members m on b.MemberID=m.MemberID
where f.PaidStatus='unpaid'

--10. Get the total fine amount for each borrow record.
SELECT BorrowID, SUM(FineAmount) AS TotalFineAmount
FROM Fines 
GROUP BY BorrowID;

--11. Show the most recently borrowed book (based on BorrowDate).
select top 1 max(borrowdate) 
from BorrowRecords

--12. List all members along with the number of books they have borrowed.
SELECT m.FullName,
  (SELECT COUNT(*) FROM BorrowRecords br WHERE br.MemberID = m.MemberID) AS BorrowCount
FROM Members m;


--13. Display books borrowed in the last 30 days.
SELECT *
FROM BorrowRecords
WHERE BorrowDate >= DATEADD(day, -30, GETDATE());

--14. Show members who have borrowed more than one book.
SELECT *
FROM Members m
WHERE (SELECT COUNT(*) FROM BorrowRecords br WHERE br.MemberID = m.MemberID) > 1;


--15. List all books that have never been borrowed.
SELECT b.*
FROM Books b
LEFT JOIN BorrowRecords br ON b.BookID = br.BookID
WHERE br.BorrowID IS NULL;

