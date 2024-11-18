-- Insert sample flights
INSERT INTO Flights (flight_number, departure_time, arrival_time, source, destination, class) VALUES
('AA101', '2024-11-20 10:00:00', '2024-11-20 12:00:00', 'New York', 'Los Angeles', 'Business'),
('UA202', '2024-11-20 14:00:00', '2024-11-20 15:30:00', 'Chicago', 'Miami', 'Economy'),
('DL303', '2024-11-21 09:00:00', '2024-11-21 11:00:00', 'Seattle', 'San Francisco', 'First'),
('SW404', '2024-11-21 16:00:00', '2024-11-21 19:00:00', 'Boston', 'Las Vegas', 'Economy'),
('JB505', '2024-11-22 08:00:00', '2024-11-22 10:30:00', 'Washington DC', 'Dallas', 'Business');

-- Insert sample passengers
INSERT INTO Passengers (first_name, last_name, seat_preference, class) VALUES
('John', 'Smith', 'Window', 'Business'),
('Emma', 'Johnson', 'Aisle', 'Economy'),
('Michael', 'Davis', 'Window', 'First'),
('Sarah', 'Wilson', 'Middle', 'Economy'),
('Robert', 'Brown', 'Aisle', 'Business');

-- Insert loyalty program records for each passenger
INSERT INTO Loyalty_Program (passenger_id, points) VALUES
(1, 5000),
(2, 1000),
(3, 10000),
(4, 500),
(5, 7500);

-- Insert seat allocations for each flight
INSERT INTO Seat_Allocation (flight_id, seat_number, status) VALUES
(1, '12A', 'Available'),
(2, '18D', 'Available'),
(3, '1A', 'Available'),
(4, '22F', 'Available'),
(5, '8C', 'Available');

-- Insert bookings
INSERT INTO Booking (flight_id, passenger_id, seat_number) VALUES
(1, 1, '12A'),    -- John Smith on AA101
(2, 2, '18D'),    -- Emma Johnson on UA202
(3, 3, '1A'),     -- Michael Davis on DL303
(4, 4, '22F'),    -- Sarah Wilson on SW404
(5, 5, '8C');    -- Robert Brown on JB505

