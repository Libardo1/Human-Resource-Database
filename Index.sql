/* 
This script demonstrates CREATE INDEX, CREATE VIEW
*/


/* 

THIS BLOCK SETS UP THE DEMONSTRATION.

SELECT AND EXECUTE ALL STATEMENTS DOWN TO THE BEGINNING OF THE DEMONSTRATION

*/

	-- Clear the decks to recreate the OnlineMusic database from scratch

	USE master;		--Set the context to the master database*/


	IF EXISTS (SELECT * from master.dbo.sysdatabases WHERE NAME='OnlineMusic') 
	DROP DATABASE OnlineMusic;


	/*Create the OnlineMusic database in the master context*/

	CREATE DATABASE OnlineMusic -- create and name the database
	ON							-- Specify File location and other details of the physical database file.
	(
	NAME=OnlineMusic,		-- Logical Name of the database
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\OnlineMusic.mdf', -- physical location for data file
	SIZE=100,				-- initial file size in megabytes
	MAXSIZE= 100,			-- maximum file size in megabytes
	FILEGROWTH = 10%		-- growth rate for file
	)

	LOG ON						-- specify the file location and other details of the log file for this database
	(
	NAME = OnlineMusicLog,	-- logical name for log file
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\LOG\OnlineMusicLog.ldf', -- Phyiscal location for log file
	SIZE=100,				-- original size of database
	MAXSIZE = 100,			-- Initial size of file in MB	
	FILEGROWTH= 10%			-- growth rate for file
	);

	GO							-- Execute this batch of SQL Commands

	/* Change the context to the OnlineMusic Database.  All subsequent operations will affect that databse */

	USE OnlineMusic;
	GO							-- Execute this batch of SQL Commands


	/* Create, load, and test four tables for the Database */

	-- Create and test the Artists table

	CREATE TABLE tblArtists		-- Create the table
	(
	ArtistID	int PRIMARY KEY NOT NULL,	-- Setup a column and designate it as primary key
	ArtistName	varchar(128)	NOT NULL	-- Setup a column	
	);

	GO							-- Execute this batch of SQL Commands


	INSERT INTO tblArtists		-- Load the tblArtists table
	VALUES
	(1, 'Lady Gaga'),
	(2, 'Phil Collins'), 
	(3, 'Maroon 5'),
	(4, 'Elvis Prestley'),
	(5, 'The Beatles'),
	(6, 'Paul McCartney'),
	(7, 'John Lennon'),
	(8, 'Frank Sinatra');
	GO							-- Execute this batch of SQL Commands
							

	-- Create and test the Songs table
	CREATE TABLE tblSongs		-- Create the Songs table
	(
	SongID		int PRIMARY KEY NOT NULL,
	SongTitle	varchar(255)	NOT NULL
	);

	GO							-- Execute this batch of SQL Commands

	INSERT INTO tblSongs		-- Put data in the Songs Table
	VALUES
	(1, 'I Wanna Hold Your Hand'),
	(2, 'Please Please Me'),
	(3, 'Band on the Run'), 
	(4, 'Starting Over'),
	(5, 'Hard Day''s Night'),
	(6, 'Hound Dog'),
	(7, 'Poker Face'),
	(8, 'All You Need is Love'),
	(9, 'One More Night'),
	(10, 'That''s All Right, Mama'),
	(11, 'One More Night'),
	(12, 'Born This Way');

	GO							-- Execute this batch of SQL Commands


	--  Create and Test the RecordLabels Table

	CREATE TABLE tblRecordLabels -- Create the RecordLabels Table
	(
	LabelID Int PRIMARY KEY NOT NULL,
	RecordLabel varchar(255) NOT NULL
	);

	GO							-- Execute this batch of SQL Commands

	INSERT INTO tblRecordLabels	-- Insert Records into RecordLabels table
	VALUES
	(1, 'Capital Records'),
	(2, 'Apple Records'),
	(3, 'Sun Records'),
	(4, 'RCA Records');

	GO							-- Execute this batch of SQL Commands 

	-- Create and test the Tracks table
	CREATE TABLE tblTracks												-- create the tblTracks table
	(
	SongID		int NOT NULL,										-- add three columns to the table
	ArtistID	int NOT NULL,
	LabelID		int NOT NULL,
	
	CONSTRAINT pk_TrackID		PRIMARY KEY (SongID, ArtistID, LabelID),	-- create a primary key composed of three columns
	
	CONSTRAINT fk_SongTracks	FOREIGN KEY(SongID)							-- Create a foreign key constraint for SongID.  Can't add a track unless the specified song id exists in the song field
		REFERENCES tblSongs(SongID)
			ON DELETE CASCADE												-- if a record is deleted from tblSongs, then delete all records in tblTracks that have contain the same SongID
			ON UPDATE NO ACTION,												-- if a SongID is updated in tblSongs, then also update all records in tblTracks containing the same SongID
			 
	CONSTRAINT fk_ArtistTracks	FOREIGN KEY(ArtistID)	
		REFERENCES tblArtists(ArtistID)
			ON DELETE NO ACTION
			ON UPDATE CASCADE,

	CONSTRAINT fk_LabelTracks	FOREIGN KEY(LabelID)	
		REFERENCES tblRecordLabels(LabelID)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
	);

	GO																	-- Execute this batch of SQL Commands

	INSERT INTO tblTracks												-- Load data into the tblTracks table
	VALUES
	(1,5,1),
	(2,5,1),
	(3,6,1),
	(4,7,2),
	(5,5,3),
	(6,4,4),
	(7,1,3),
	(8,5,4),
	(9,3,4),
	(10,4,3),
	(11,2,2),
	(12,2,3);

	GO															-- Execute this batch of SQL Commands


	INSERT INTO tblSongs
	VALUES
	(14, 'Another Day in Paradise'),
	(15, 'You''l Be in My Heart'),
	(16, 'I Don''t Care Anymore'),
	(17, 'Begin the Beguine'),
	(18, 'White Christmas');

	INSERT INTO tblArtists
	VALUES
	(10, 'Phil Collins'),
	(11, 'Charlie XCS'),
	(12, 'Sam Smith'), 
	(13, 'Magic!');  

	INSERT INTO tblRecordLabels
	VALUES 
	(6, 'Virgin Records'),
	(7, 'Walt Disney Records'),
	(8, 'Atlantic Records'),
	(9, 'Rhino Records'),
	(10, 'EMI'),
	(11, 'PolyGram');

	INSERT INTO tblTracks
	VALUES 
	(14, 10 ,6),
	(15, 10 ,7),
	(16, 10 ,8);

/* Demonstrate adding a field to a table*/

	--Add a new TrackSales field to the table
	ALTER TABLE 
		tblTracks
	ADD  
		TrackSales int NOT NULL DEFAULT 0;
	GO

	-- Show that the new column exists and is populated with zeros
	SELECT * 
	FROM 
		tblTracks; 
	GO

	-- Record the sale of 1 million copies of the song, "I wanna hold your hand"
	UPDATE 
		TblTracks
	SET 
		TrackSales = TrackSales + 1
	WHERE 
		SongID = 1;
	GO

	-- Show that "I wanna hold your hand sold 1 million
	SELECT * FROM tblTracks; 


	/* Demonstrate the UPDATE Clause with Nested Query*/

	/*-- Record an additional 1 Million sales of "I wanna hold your hand" using nested query */

	--!!! Why is this considered bad form?
	-- IMPLIED JOIN Slow for high-volume queries.  With join, all queries run against integrated temorary table
		
		-- Show implied JOIN via Nesting
		UPDATE 
			tblTracks		
		SET 
			tblTracks.TrackSales = tblTracks.TrackSales + 1
		WHERE 
			SongID IN (
				 SELECT 
					SongID 
				 FROM 
					TblSongs 
				 WHERE 
					SongTitle = 'I Wanna Hold Your Hand'
				 );
		GO
		
		-- Show effects of update
		SELECT * From tblTracks;
		GO

		-- Better Solution - Inner Join 
		UPDATE 
			tblTracks		
		SET 
			tblTracks.TrackSales = tblTracks.TrackSales + 1
		FROM 
			tblTracks	
		INNER JOIN 
			tblSongs AS sng
		ON 
			tblTracks.SongID = sng.SongID
		WHERE 
			SongTitle = 'I wanna hold your hand';
		GO
		
		-- Show effects of update
		SELECT * FROM tblTracks;
		GO
			

	/* Demonstrate updating one table with values from another table */

	-- It would take a lot of coding to update TrackSales 1 record at a time.

	-- Notice that four tracks remain at zero - we didn't record any sales for them.  

	-- Populate the new TrackSales column quickly 
	-- Create a temporary table to update sales of tracks
	CREATE TABLE tblTempTrackSalesData		
	(
	 SongID		int PRIMARY KEY NOT NULL,
	 TrackSales	int	NOT NULL
	);
	GO

	-- Load the temorary table with sales by song
	INSERT INTO tblTempTrackSalesData
	VALUES
	(1,3),
	(2,6),
	(3,9),
	(4,5),
	(5,7),
	(6,1),
	(7,9),
	(8,6),
	(9,4),
	(10,3),
	(11,7),
	(12,2);
	GO
	
	-- Show that 12 tracks in the temporary table were updated with sales. 	
	SELECT * FROM tblTempTrackSalesData;

	-- Add sales data from the temporary table into the Track table
	UPDATE tblTracks
	SET 
		tblTracks.TrackSales = tblTracks.TrackSales + dat.TrackSales
	FROM 
		tblTracks		
	INNER JOIN 
		tblTempTrackSalesData	AS dat
	ON 
		tblTracks.SongID = dat.SongID;
	GO
	
	-- Show effects of update
	SELECT * FROM tblTracks;
	GO




/*  

THIS IS THE BEGINNING OF THE DEMONSTRATION
SELECT AND EXECUTE EVERYTHING ABOVE THIS COMMNENT TO SET UP THE THE DEMONSTRATION
COPY STATEMENTS BELOW INTO CLASS NOTES

*/

/* SQL Challenges */

	-- What are the names of artists who have made tracks,  and what is the total number of tracks each artist has sold?
	SELECT art.ArtistName, SUM (trk.TrackSales) as 'TrackSales'
	FROM 
		tblArtists AS art
	INNER JOIN
		tblTracks AS trk
	ON
		art.ArtistID = trk.ArtistID
	GROUP BY ArtistName;

	GO

	-- Change the query to sort the results in descending order by the total tracks sold
	SELECT art.ArtistName, SUM (trk.TrackSales) as 'TrackSales'
	FROM 
		tblArtists AS art
	INNER JOIN
		tblTracks AS trk
	ON
		art.ArtistID = trk.ArtistID
	GROUP BY ArtistName
	-- Sort in descending order by total tracks sold
	ORDER BY SUM(trk.TrackSales) DESC;

	GO

	/* Demonstrate Creating Indexes */

	-- Speed up the join of the Artists and Tracks tables
	-- Create Indexes on tblTracks and tblArtists over ArtistID 
	CREATE INDEX ndx_trk_ArtistID ON tblTracks (ArtistID);
	CREATE INDEX ndx_art_ArtistID ON tblArtists (ArtistID);
	
	GO

	-- Re-run the query using the newly created Index
	SELECT art.ArtistName, SUM (trk.TrackSales) as 'TrackSales'
	FROM 
		tblArtists AS art
		INNER JOIN
		tblTracks AS trk
	ON
		art.ArtistID = trk.ArtistID
	GROUP BY ArtistName
	ORDER BY SUM(trk.TrackSales) DESC;
	
	GO

	/* Demonstrate Mulitple Joins, Mulitple WHERE conditions */

	-- Name artists who never recorded for Capital or RCA, the songs each recorded, the label for which each was recorded, and the number of tracks sold for each song.  Exclude Songs for which no tracks have been sold.
	SELECT art.ArtistName,  sng.SongTitle, lbl.RecordLabel, trk.TrackSales
	FROM 
		tblArtists AS art
	INNER JOIN 
		tblTracks AS trk
	ON 
		art.ArtistID = trk.ArtistID
	INNER JOIN 
		tblSongs AS sng
	ON
		sng.SongID = trk.SongID
	INNER JOIN 
		tblRecordLabels as lbl
	ON 
		lbl.LabelID = trk.LabelID
	WHERE 
		lbl.RecordLabel <> 'Capital Records' AND
		lbl.RecordLabel <> 'RCA Records' AND
		-- Eliminate tracks with no sales
		trk.TrackSales > 0;
GO

	/* 	Demonstrate Creating a View */

	-- Create a veiw that shows artists, songs, labels, and track sales for songs not recorded at Capital or RCA
	-- Exludes songs for which no sales have been recorded

	CREATE VIEW vw_ArtistTrackSales AS

	SELECT art.ArtistName,  sng.SongTitle, lbl.RecordLabel, trk.TrackSales
	FROM 
		tblArtists AS art
	INNER JOIN 
		tblTracks AS trk
	ON 
		art.ArtistID = trk.ArtistID
	INNER JOIN 
		tblSongs AS sng
	ON
		sng.SongID = trk.SongID
	INNER JOIN 
		tblRecordLabels as lbl
	ON 
		lbl.LabelID = trk.LabelID
	WHERE 
		lbl.RecordLabel <> 'Capital Records' AND
		lbl.RecordLabel <> 'RCA Records' AND
		-- Eliminate tracks with no sales
		trk.TrackSales > 0;

	GO


	-- Show that the view can be used as if it were a table

	SELECT * from vw_ArtistTrackSales;

	GO
