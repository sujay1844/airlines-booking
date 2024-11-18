-- Create Flights table with class enum
CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    class ENUM('Economy', 'Business', 'First') NOT NULL,
    CONSTRAINT chk_times CHECK (departure_time < arrival_time)
);

-- Create Passengers table with enums for preferences and class
CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    seat_preference ENUM('Window', 'Aisle', 'Middle') NOT NULL,
    class ENUM('Economy', 'Business', 'First') NOT NULL
);

-- Create Seat_Allocation table with status enum
CREATE TABLE Seat_Allocation (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    status ENUM('Available', 'Booked', 'Blocked') NOT NULL DEFAULT 'Available',
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    CONSTRAINT unique_seat_flight UNIQUE (flight_id, seat_number)
);

-- Create Loyalty_Program table with derived points
CREATE TABLE Loyalty_Program (
    passenger_id INT PRIMARY KEY,
    points INT NOT NULL DEFAULT 0,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

-- Create Booking table with relationships
CREATE TABLE Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id, seat_number) REFERENCES Seat_Allocation(flight_id, seat_number),
    CONSTRAINT unique_passenger_flight UNIQUE (passenger_id, flight_id)
);

-- Indexes for better query performance
CREATE INDEX idx_flight_datetime ON Flights(departure_time, arrival_time);
CREATE INDEX idx_passenger_name ON Passengers(last_name, first_name);
CREATE INDEX idx_booking_flight ON Booking(flight_id);
CREATE INDEX idx_booking_passenger ON Booking(passenger_id);

-- Triggers to maintain data consistency

-- Trigger to update seat status when booking is made
DELIMITER //
CREATE TRIGGER after_booking_insert
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
    UPDATE Seat_Allocation 
    SET status = 'Booked'
    WHERE flight_id = NEW.flight_id 
    AND seat_number = NEW.seat_number;
END;
//

-- Trigger to update seat status when booking is cancelled
CREATE TRIGGER after_booking_delete
AFTER DELETE ON Booking
FOR EACH ROW
BEGIN
    UPDATE Seat_Allocation 
    SET status = 'Available'
    WHERE flight_id = OLD.flight_id 
    AND seat_number = OLD.seat_number;
END;
//
DELIMITER ;

-- Stored procedure to update passenger seat preferences
DELIMITER //
CREATE PROCEDURE update_seat_preference(
    IN p_passenger_id INT,
    IN p_new_preference ENUM('Window', 'Aisle', 'Middle')
)
BEGIN
    -- Declare variables to handle errors
    DECLARE passenger_exists INT;
    
    -- Check if passenger exists
    SELECT COUNT(*) INTO passenger_exists 
    FROM Passengers 
    WHERE passenger_id = p_passenger_id;
    
    -- Handle invalid passenger ID
    IF passenger_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid passenger ID provided';
    ELSE
        -- Update the passenger's seat preference
        UPDATE Passengers 
        SET seat_preference = p_new_preference
        WHERE passenger_id = p_passenger_id;
        
        -- Return success message
        SELECT CONCAT('Seat preference updated successfully for passenger ID: ', p_passenger_id) AS message;
    END IF;
END //
DELIMITER ;
