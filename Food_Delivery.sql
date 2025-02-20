
Create database Food_Delivery;
Use Food_Delivery;
-- 1. Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Restaurants Table
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    rating FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Menu Table
CREATE TABLE Menu (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending', 'Processing', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- 5. Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Menu(item_id) ON DELETE CASCADE
);

-- 6. Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method ENUM('Cash', 'Card', 'UPI', 'Net Banking') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- 7. Delivery Table
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    delivery_status ENUM('Pending', 'Out for Delivery', 'Delivered', 'Failed') DEFAULT 'Pending',
    estimated_time TIME,
    delivery_person VARCHAR(100),
    contact VARCHAR(15),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- 8. Ratings & Reviews Table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- 9. Admin Table
CREATE TABLE Admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NULL, -- NULL means system admin, otherwise restaurant-specific admin
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Super Admin', 'Restaurant Admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE SET NULL
);
-- Insert Users (10 users)
INSERT INTO Users (name, email, phone, address) VALUES
('John Doe', 'john@example.com', '9876543210', '123 Street, City'),
('Jane Smith', 'jane@example.com', '9123456780', '456 Avenue, City'),
('Mike Johnson', 'mike@example.com', '9865432109', '789 Road, City'),
('Emily Davis', 'emily@example.com', '9854321098', '1011 Blvd, City'),
('Chris Brown', 'chris@example.com', '9843210987', '1213 Lane, City'),
('Sarah Lee', 'sarah@example.com', '9832109876', '1415 Street, City'),
('David Wilson', 'david@example.com', '9821098765', '1617 Square, City'),
('Laura Martinez', 'laura@example.com', '9810987654', '1819 Court, City'),
('Robert Taylor', 'robert@example.com', '9809876543', '2021 Drive, City'),
('Sophia White', 'sophia@example.com', '9798765432', '2223 Plaza, City');

-- Insert Restaurants (10 restaurants)
INSERT INTO Restaurants (name, location, rating) VALUES
('Tasty Bites', 'Downtown', 4.5),
('Foodie Hub', 'Uptown', 4.2),
('Spice Avenue', 'City Center', 4.6),
('The Hungry Bear', 'Suburb', 4.3),
('Golden Spoon', 'Midtown', 4.7),
('Urban Eats', 'Westside', 4.4),
('Flavors Express', 'North End', 4.1),
('Crispy Crust', 'South Bay', 4.8),
('The Vegan Place', 'Eco Park', 4.5),
('Royal Feast', 'High Street', 4.9);

-- Insert Menu Items (10 per restaurant)
INSERT INTO Menu (restaurant_id, name, price, category) VALUES
(1, 'Burger', 120.00, 'Fast Food'),
(1, 'Pasta', 250.00, 'Italian'),
(1, 'Pizza', 300.00, 'Fast Food'),
(1, 'Salad', 150.00, 'Healthy'),
(1, 'Grilled Sandwich', 180.00, 'Snacks'),
(2, 'Tandoori Chicken', 450.00, 'Indian'),
(2, 'Butter Naan', 60.00, 'Indian'),
(2, 'Paneer Tikka', 300.00, 'Indian'),
(2, 'Dal Makhani', 220.00, 'Indian'),
(2, 'Gulab Jamun', 100.00, 'Dessert');

-- Insert Orders (10 orders)
INSERT INTO Orders (user_id, restaurant_id, total_amount, status) VALUES
(1, 1, 370.00, 'Pending'),
(2, 2, 450.00, 'Processing'),
(3, 3, 620.00, 'Out for Delivery'),
(4, 4, 280.00, 'Delivered'),
(5, 5, 150.00, 'Cancelled'),
(6, 6, 510.00, 'Pending'),
(7, 7, 700.00, 'Processing'),
(8, 8, 320.00, 'Delivered'),
(9, 9, 480.00, 'Pending'),
(10, 10, 560.00, 'Out for Delivery');

-- Insert Order Items (10 items for different orders)
INSERT INTO Order_Items (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 240.00),
(1, 2, 1, 250.00),
(2, 3, 1, 300.00),
(2, 4, 2, 300.00),
(3, 5, 3, 540.00),
(4, 6, 1, 450.00),
(4, 7, 2, 120.00),
(5, 8, 1, 300.00),
(6, 9, 2, 440.00),
(7, 10, 3, 300.00);

-- Insert Payments (10 payments)
INSERT INTO Payments (order_id, payment_method, status, transaction_id) VALUES
(1, 'UPI', 'Completed', 'TXN12345XYZ'),
(2, 'Card', 'Completed', 'TXN67890ABC'),
(3, 'Net Banking', 'Failed', 'TXN45678DEF'),
(4, 'UPI', 'Completed', 'TXN98765GHI'),
(5, 'Cash', 'Pending', NULL),
(6, 'Card', 'Completed', 'TXN54321JKL'),
(7, 'UPI', 'Completed', 'TXN11223MNO'),
(8, 'Net Banking', 'Completed', 'TXN33445PQR'),
(9, 'Cash', 'Pending', NULL),
(10, 'UPI', 'Failed', 'TXN99887STU');

-- Insert Delivery Status (10 deliveries)
INSERT INTO Delivery (order_id, delivery_status, estimated_time, delivery_person, contact) VALUES
(1, 'Out for Delivery', '00:30:00', 'Rahul Singh', '9876543210'),
(2, 'Delivered', '00:45:00', 'Amit Kumar', '9765432109'),
(3, 'Pending', '01:00:00', 'Neha Sharma', '9854321098'),
(4, 'Delivered', '00:20:00', 'Ravi Yadav', '9843210987'),
(5, 'Failed', '00:50:00', 'Pooja Mehta', '9832109876'),
(6, 'Out for Delivery', '00:25:00', 'Mohit Chauhan', '9821098765'),
(7, 'Delivered', '00:55:00', 'Sneha Kapoor', '9810987654'),
(8, 'Pending', '01:10:00', 'Vishal Singh', '9809876543'),
(9, 'Out for Delivery', '00:40:00', 'Anjali Gupta', '9798765432'),
(10, 'Delivered', '00:35:00', 'Suresh Verma', '9787654321');

-- Insert Reviews (10 reviews)
INSERT INTO Reviews (user_id, restaurant_id, rating, comment) VALUES
(1, 1, 5, 'Great food and service!'),
(2, 2, 4, 'Loved the pizza, will order again.'),
(3, 3, 5, 'The best restaurant experience.'),
(4, 4, 3, 'Food was okay, but slow delivery.'),
(5, 5, 2, 'Not happy with the quality.'),
(6, 6, 4, 'Good taste, but expensive.'),
(7, 7, 5, 'Amazing flavors!'),
(8, 8, 3, 'Could be better, late delivery.'),
(9, 9, 5, 'Excellent vegan options!'),
(10, 10, 4, 'Nice ambiance, decent food.');

-- Insert Admins (10 admins)
INSERT INTO Admins (restaurant_id, name, email, password_hash, role) VALUES
(NULL, 'System Admin', 'admin@system.com', 'hashedpassword123', 'Super Admin'),
(1, 'Tasty Bites Admin', 'admin@tastybites.com', 'hashedpassword456', 'Restaurant Admin'),
(2, 'Foodie Hub Admin', 'admin@foodiehub.com', 'hashedpassword789', 'Restaurant Admin'),
(3, 'Spice Avenue Admin', 'admin@spiceavenue.com', 'hashedpassword101', 'Restaurant Admin'),
(4, 'Hungry Bear Admin', 'admin@hungrybear.com', 'hashedpassword202', 'Restaurant Admin'),
(5, 'Golden Spoon Admin', 'admin@goldenspoon.com', 'hashedpassword303', 'Restaurant Admin'),
(6, 'Urban Eats Admin', 'admin@urbaneats.com', 'hashedpassword404', 'Restaurant Admin'),
(7, 'Flavors Express Admin', 'admin@flavorexpress.com', 'hashedpassword505', 'Restaurant Admin'),
(8, 'Crispy Crust Admin', 'admin@crispycrust.com', 'hashedpassword606', 'Restaurant Admin'),
(9, 'Vegan Place Admin', 'admin@veganplace.com', 'hashedpassword707', 'Restaurant Admin');


-- 1. Fetch All Pending Orders with Details
SELECT Orders.order_id, Users.name AS customer, Restaurants.name AS restaurant, 
       Orders.total_amount, Orders.status, Menu.name AS item, Order_Items.quantity 
FROM Orders
JOIN Users ON Orders.user_id = Users.user_id
JOIN Restaurants ON Orders.restaurant_id = Restaurants.restaurant_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Menu ON Order_Items.item_id = Menu.item_id
WHERE Orders.status = 'Pending';

-- 2. Get Delivery Status for a Given Order
SELECT Orders.order_id, Delivery.delivery_status, Delivery.estimated_time, 
       Delivery.delivery_person, Delivery.contact 
FROM Delivery
JOIN Orders ON Delivery.order_id = Orders.order_id
WHERE Orders.order_id = 1;

-- 3. View Top Rated Restaurants
SELECT name, location, rating 
FROM Restaurants 
ORDER BY rating DESC 
LIMIT 5;

-- 4. Check Payment Status of an Order
SELECT Payments.payment_id, Orders.order_id, Users.name AS customer, Payments.status, Payments.transaction_id 
FROM Payments
JOIN Orders ON Payments.order_id = Orders.order_id
JOIN Users ON Orders.user_id = Users.user_id
WHERE Payments.status = 'Completed';

-- 5. Fetch Admins
SELECT admin_id, name, email, role, IFNULL(restaurant_id, 'System Admin') AS assigned_restaurant
FROM Admins;
