import mysql.connector
from datetime import datetime
from typing import Optional

class AirlineBookingSystem:
    def __init__(self):
        # Initialize database connection
        self.conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root_password",
            database="airlines"
        )
        self.cursor = self.conn.cursor(dictionary=True)

    def display_available_flights(self):
        query = """
        SELECT f.flight_id, f.flight_number, f.source, f.destination, 
               f.departure_time, f.class
        FROM Flights f
        """
        self.cursor.execute(query)
        flights = self.cursor.fetchall()
        
        print("\nAvailable Flights:")
        print("-" * 80)
        for flight in flights:
            print(f"Flight ID: {flight['flight_id']}")
            print(f"Flight Number: {flight['flight_number']}")
            print(f"From: {flight['source']} To: {flight['destination']}")
            print(f"Departure: {flight['departure_time']}")
            print(f"Class: {flight['class']}")
            print("-" * 80)

    def display_available_seats(self, flight_id: int):
        query = """
        SELECT seat_number, status
        FROM Seat_Allocation
        WHERE flight_id = %s AND status = 'Available'
        """
        self.cursor.execute(query, (flight_id,))
        seats = self.cursor.fetchall()
        
        print(f"\nAvailable seats for Flight ID {flight_id}:")
        for seat in seats:
            print(f"Seat {seat['seat_number']}: {seat['status']}")

    def create_booking(self, flight_id: int, passenger_id: int, seat_number: str) -> Optional[int]:
        try:
            # Check if seat is available
            check_query = """
            SELECT status FROM Seat_Allocation
            WHERE flight_id = %s AND seat_number = %s
            """
            self.cursor.execute(check_query, (flight_id, seat_number))
            result = self.cursor.fetchone()
            
            if not result or result['status'] != 'Available':
                print("This seat is not available!")
                return None

            # Create booking
            insert_query = """
            INSERT INTO Booking (flight_id, passenger_id, seat_number)
            VALUES (%s, %s, %s)
            """
            self.cursor.execute(insert_query, (flight_id, passenger_id, seat_number))
            self.conn.commit()
            
            # The trigger will automatically update the seat status
            
            return self.cursor.lastrowid
            
        except mysql.connector.Error as err:
            print(f"Error creating booking: {err}")
            self.conn.rollback()
            return None

    def close(self):
        self.cursor.close()
        self.conn.close()

def main():
    booking_system = AirlineBookingSystem()
    
    try:
        while True:
            print("\n=== SkyHigh Airlines Booking System ===")
            print("1. View Available Flights")
            print("2. View Available Seats for a Flight")
            print("3. Create New Booking")
            print("4. Exit")
            
            choice = input("Enter your choice (1-4): ")
            
            if choice == "1":
                booking_system.display_available_flights()
            
            elif choice == "2":
                flight_id = int(input("Enter Flight ID: "))
                booking_system.display_available_seats(flight_id)
            
            elif choice == "3":
                flight_id = int(input("Enter Flight ID: "))
                passenger_id = int(input("Enter Passenger ID: "))
                seat_number = input("Enter Seat Number: ")
                
                booking_id = booking_system.create_booking(flight_id, passenger_id, seat_number)
                if booking_id:
                    print(f"\nBooking created successfully! Booking ID: {booking_id}")
                    print("Seat status has been automatically updated to 'Booked'")
            
            elif choice == "4":
                break
            
            else:
                print("Invalid choice. Please try again.")

    finally:
        booking_system.close()

if __name__ == "__main__":
    main() 