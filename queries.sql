-- Example query to display passenger information with discounts
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    1000.00 AS base_ticket_price,  -- Example base price, replace with actual prices
    calculate_discount(lp.points, 1000.00) AS discounted_price,
    lp.points AS loyalty_points
FROM 
    Passengers p
    JOIN Loyalty_Program lp ON p.passenger_id = lp.passenger_id
ORDER BY 
    lp.points DESC;