High-Level Purpose
The purpose of this system design document is to provide a comprehensive guide for setting up, configuring, and managing a MongoDB instance using Docker, 
enabling replication to support transactions, and integrating with a Node.js backend and a React frontend for a seamless user experience. 
This document also covers the implementation details for authentication, profile management, and order processing via the GoLang API. 
The goal is to ensure that the setup is robust, scalable, and secure, enabling efficient handling of user data and orders, 
with an emphasis on maintaining data consistency and integrity through replication.
System Topology Diagram
![updated_architecture_diagram](https://github.com/user-attachments/assets/f83e115a-b049-455d-b39a-86920591834c)


    

System Topology Description
Components:
React Frontend

User Browser: The user interface where users interact with the application.
Functionalities: Users can log in, view and update their profiles, and place orders.
Integration: Interacts with the Node.js server to fetch and update data.
Node.js Server (Express + Axios)

API: Manages the API endpoints for user authentication, profile management, and order processing.
Integration: Acts as a middleware between the React frontend and the MongoDB database.
Security: Handles basic authentication to secure the API endpoints.
MongoDB Container (Replica Set)

mongod: The MongoDB database instance running in a Docker container.
Replication: Configured with a replica set (rs0) to ensure data consistency and support transactions.
Golang API

AddUser: Handles the addition of new users to the MongoDB database.
UpdateUser: Manages updates to user profiles.
GetUserProfile: Gets the user profile
ValidateUser: makes sure the username and password is valid
PlaceOrder: Processes user orders and updates the stock of items in the MongoDB database.
DeleteUser: Removes the User from the database
GetAllUsers: Retreives all the users from the database
CreateOrder: Create a new order respective to the items in the cart and the stock 
GetOrder: Gets the Order 
GetOrderByUserID: Gets the Order history based on UserID
AddItem: Adds a menu item to the website
GetMenuItem: Gets the menu item 
System Interaction Flow
User Authentication:

The user logs in through the React frontend.
The login request is sent to the Node.js server, which forwards it to the GoLang API for validation.
Upon successful validation, a token is stored in the local storage of the user's browser.
Profile Management:

The user can view and update their profile via the React frontend.
The profile fetch and update requests are sent to the Node.js server.
The Node.js server interacts with the GoLang API to fetch or update the user data in the MongoDB database.
Order Processing:

The user places an order through the React frontend.
The order details are sent to the Node.js server.
The Node.js server forwards the order to the GoLang API for processing.
The GoLang API updates the MongoDB database, ensuring the stock is appropriately adjusted.
Replication and Transactions:

MongoDB is configured with a replica set to ensure data consistency and support transactions.
This setup allows for high availability and fault tolerance.

Use Cases:
1. User Signup
Description: Allows a new user to create an account.
Actors: User, React Frontend, Node.js Server, GoLang API, MongoDB.
Preconditions: The user must not already have an account.
Postconditions: A new user account is created and stored in the MongoDB database.

Flow:

The user fills in the signup form on the React frontend.
The frontend sends a POST request to the Node.js server with the user's details.
The Node.js server forwards the request to the GoLang API.
The GoLang API processes the request and stores the new user details in the MongoDB database.
The user receives a confirmation message upon successful signup.
Example JSON Payload:

{
  "name": "John Doe",
  "email": "johndoe@example.com",
  "address": "123 Main St",
  "username": "johndoe",
  "password": "securepassword"
}
2. User Login
Description: Allows an existing user to log into the system.
Actors: User, React Frontend, Node.js Server, GoLang API, MongoDB.
Preconditions: The user must have an existing account.
Postconditions: The user is authenticated and granted access to the system.

Flow:

The user enters their username and password on the React frontend.
The frontend sends a POST request to the Node.js server with the login credentials.
The Node.js server forwards the request to the GoLang API for validation.
The GoLang API checks the credentials against the MongoDB database.
Upon successful validation, the server responds with a token that the frontend stores in local storage.
Example JSON Payload:

{
  "username": "johndoe",
  "password": "securepassword"
}
3. Profile Management
Description: Allows a user to view and update their profile information.
Actors: User, React Frontend, Node.js Server, GoLang API, MongoDB.
Preconditions: The user must be logged in.
Postconditions: The user's profile information is updated in the MongoDB database.

Flow:

The user navigates to the profile management page on the React frontend.
The frontend sends a GET request to the Node.js server to fetch the user's profile information.
The Node.js server forwards the request to the GoLang API, which retrieves the data from the MongoDB database.
The frontend displays the profile information to the user.
The user updates their profile details and submits the form.
The frontend sends a PUT request to the Node.js server with the updated profile information.
The Node.js server forwards the request to the GoLang API, which updates the MongoDB database.
The user receives a confirmation message upon successful profile update.
Example JSON Payload (for update):

{
  "id": "123456",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "address": "123 Main St",
  "username": "johndoe",
  "password": "newsecurepassword"
}
4. Order Processing
Description: Allows a user to place an order and manage their cart.
Actors: User, React Frontend, Node.js Server, GoLang API, MongoDB.
Preconditions: The user must be logged in and have items in their cart.
Postconditions: The order is processed, and the items' stock is updated in the MongoDB database.

Flow:

The user adds items to their cart on the React frontend.
The user reviews their cart and clicks the "Order Now" button.
The frontend sends a POST request to the Node.js server with the order details.
The Node.js server forwards the request to the GoLang API.
The GoLang API processes the order, checks the stock, and updates the MongoDB database.
The user receives a confirmation message with the order ID upon successful order placement.
Example JSON Payload:

{
  "userId": "123456",
  "items": [
    {
      "name": "Big Mac",
      "price": 5.99,
      "count": 2,
      "calories": 563,
      "stock": 10
    }
  ],
  "total": 11.98
}
5. Viewing Order History
Description: Allows a user to view their past orders.
Actors: User, React Frontend, Node.js Server, GoLang API, MongoDB.
Preconditions: The user must be logged in.
Postconditions: The user can see their past orders.

Flow:

The user navigates to the order history page on the React frontend.
The frontend sends a GET request to the Node.js server to fetch the user's order history.
The Node.js server forwards the request to the GoLang API, which retrieves the data from the MongoDB database.
The frontend displays the order history to the user.
Example JSON Response:

[
  {
    "orderId": "abcdef123456",
    "userId": "123456",
    "items": [
      {
        "name": "Big Mac",
        "price": 5.99,
        "count": 2
      },
      {
        "name": "Fries",
        "price": 2.49,
        "count": 1
      }
    ],
    "total": 14.47,
    "date": "2024-06-28T12:34:56Z"
  }
]

Interaction Diagram for User Signup

User                   React Frontend        Node.js Server      GoLang API          MongoDB
 |                           |                      |                 |                  |
 |-- Fill Signup Form ------>|                      |                 |                  |
 |                           |-- POST /signup ----->|                 |                  |
 |                           |                      |-- AddUser ----->|                  |
 |                           |                      |                 |-- Insert ------->
 |                           |                      |                 |<-- Acknowledge --
 |                           |<-- Signup Success ---|                 |                  |
 |<-- Display Confirmation --|                      |                 |                  |
Interaction Diagram for User Login

User                   React Frontend        Node.js Server      GoLang API          MongoDB
 |                           |                      |                 |                  |
 |-- Enter Credentials ----->|                      |                 |                  |
 |                           |-- POST /login ------>|                 |                  |
 |                           |                      |-- ValidateUser ->|                 |
 |                           |                      |                 |-- FindUser ---->
 |                           |                      |                 |<-- Acknowledge --
 |                           |<-- Auth Token -------|                 |                  |
 |<-- Store Token -----------|                      |                 |                  |
 |                           |                      |                 |                  |
Interaction Diagram for Profile Management

User                   React Frontend        Node.js Server      GoLang API          MongoDB
 |                           |                      |                 |                  |
 |-- View Profile ---------->|                      |                 |                  |
 |                           |-- GET /profile ------>|                 |                  |
 |                           |                      |-- GetUser ------>|                  |
 |                           |                      |                 |-- FindUser ---->
 |                           |                      |                 |<-- User Data ----|
 |                           |<-- Display Profile --|                 |                  |
 |                           |                      |                 |                  |
 |-- Update Profile -------->|                      |                 |                  |
 |                           |-- PUT /profile ------>|                 |                  |
 |                           |                      |-- UpdateUser --->|                  |
 |                           |                      |                 |-- Update ------->|
 |                           |                      |                 |<-- Acknowledge --|
 |<-- Confirmation ----------|                      |                 |                  |
Interaction Diagram for Order Processing

User                   React Frontend        Node.js Server      GoLang API          MongoDB
 |                           |                      |                 |                  |
 |-- Add Items to Cart ----->|                      |                 |                  |
 |                           |                      |                 |                  |
 |-- Place Order ----------->|                      |                 |                  |
 |                           |-- POST /order ------>|                 |                  |
 |                           |                      |-- PlaceOrder --->|                  |
 |                           |                      |                 |-- UpdateStock --->
 |                           |                      |                 |<-- Acknowledge --|
 |                           |<-- Order ID ---------|                 |                  |
 |<-- Confirmation ----------|                      |                 |                  |



 
Interaction Diagram for Viewing Order History

User                   React Frontend        Node.js Server      GoLang API          MongoDB
 |                           |                      |                 |                  |
 |-- View Order History ---->|                      |                 |                  |
 |                           |-- GET /orders ------>|                 |                  |
 |                           |                      |-- GetOrders ---->|                  |
 |                           |                      |                 |-- FindOrders ---->
 |                           |                      |                 |<-- Orders Data --|
 |                           |<-- Display Orders ---|                 |                  |
 |<-- Display Orders History-|                      |                 |                  |

1. Users Collection
Purpose: To store user account information.
Collection Name: users
Fields:

_id: ObjectId, the unique identifier for each user.
username: String, the unique username for the user.
password: String, the hashed password for the user.
email: String, the user's email address.
name: String, the user's full name.
address: String, the user's address.
created_at: Date, the date and time when the user account was created.
Schema:

json
Copy code
{
  "_id": "ObjectId",
  "username": "String",
  "password": "String",
  "email": "String",
  "name": "String",
  "address": "String",
  "created_at": "Date"
}
2. Profiles Collection
Purpose: To store user profile information.
Collection Name: profiles
Fields:

_id: ObjectId, the unique identifier for each profile.
user_id: ObjectId, references the user this profile belongs to.
bio: String, a short biography of the user.
profile_picture_url: String, the URL to the user's profile picture.
preferences: Object, stores user preferences as key-value pairs.
Schema:

json
Copy code
{
  "_id": "ObjectId",
  "user_id": "ObjectId",
  "bio": "String",
  "profile_picture_url": "String",
  "preferences": {
    "key1": "value1",
    "key2": "value2"
  }
}
3. Items Collection
Purpose: To store menu items available for order.
Collection Name: items
Fields:

_id: ObjectId, the unique identifier for each item.
name: String, the name of the item.
price: Number, the price of the item.
calories: Number, the number of calories in the item.
stock: Number, the current stock level of the item.
created_at: Date, the date and time when the item was added.
Schema:

json
Copy code
{
  "_id": "ObjectId",
  "name": "String",
  "price": "Number",
  "calories": "Number",
  "stock": "Number",
  "created_at": "Date"
}
4. Orders Collection
Purpose: To store orders placed by users.
Collection Name: orders
Fields:

_id: ObjectId, the unique identifier for each order.
user_id: ObjectId, references the user who placed the order.
items: Array, an array of items ordered (each containing item details).
total: Number, the total cost of the order.
status: String, the current status of the order (e.g., "pending", "completed").
created_at: Date, the date and time when the order was placed.
Schema:

json
Copy code
{
  "_id": "ObjectId",
  "user_id": "ObjectId",
  "items": [
    {
      "item_id": "ObjectId",
      "name": "String",
      "price": "Number",
      "count": "Number"
    }
  ],
  "total": "Number",
  "status": "String",
  "created_at": "Date"
}
Relationships
User to Profile: One-to-One (Each user has one profile).
User to Orders: One-to-Many (Each user can place multiple orders).
Order to Items: Many-to-Many (Each order can contain multiple items, and each item can be part of multiple orders).
 1. Scalability
Constraint: The system must handle a growing number of users and increasing volumes of data efficiently.
Implications:
Use of MongoDB replica sets for horizontal scaling and data redundancy.
Design of the backend to support load balancing and distributed processing.
Implementation of efficient indexing strategies.
2. Security
Constraint: The system must ensure the security of user data and prevent unauthorized access.
Implications:
Use of HTTPS for secure data transmission.
Implementation of basic authentication for API access.
Storage of passwords in a hashed format using bcrypt.
Proper handling of authentication tokens in the frontend.
3. Data Consistency
Constraint: The system must maintain data consistency, particularly during concurrent operations.
Implications:
Use of MongoDB transactions for atomic operations.
Implementation of optimistic concurrency control (OCC) to handle concurrent updates.
Proper design of schemas to ensure data integrity.
4. Performance
Constraint: The system must provide a responsive user experience and fast processing times for database operations.
Implications:
Optimization of database queries through indexing.
Minimization of round-trip times between frontend and backend.
Efficient handling of large datasets.
5. Reliability and Availability
Constraint: The system must be highly available and reliable, with minimal downtime.
Implications:
Use of MongoDB replica sets to ensure data availability.
Design of the system to handle failover and recovery scenarios.
Regular backups and monitoring of system health.
6. Maintainability
Constraint: The system must be maintainable and allow for easy updates and bug fixes.
Implications:
Use of modular design principles to separate concerns and simplify codebase management.
Implementation of proper logging and error handling.
Comprehensive documentation and adherence to coding standards.
7. Cost
Constraint: The system must be cost-effective, considering both development and operational expenses.
Implications:
Use of open-source technologies like MongoDB, Node.js, and GoLang.
Efficient use of cloud resources to minimize operational costs.
Scalability features to ensure that costs grow linearly with usage.
8. Compliance
Constraint: The system must comply with relevant data protection and privacy regulations.
Implications:
Implementation of data encryption and secure storage practices.
Adherence to regulations like GDPR and CCPA.
Provision of user controls for data access and deletion.
9. User Experience
Constraint: The system must provide a seamless and intuitive user experience.
Implications:
Design of a user-friendly frontend with React.
Implementation of responsive design principles to support various devices.
Regular user testing and feedback incorporation.

Concurrency Control: 

We used a replica set (rs0) in MongoDB for concurrency control where we set up a replica set and leveraged MongoDB's features to manage consistency and availability of data.
