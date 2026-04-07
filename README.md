<<<<<<< HEAD
# EVENT_MANAGEMENT_SYSTEM
=======
# 🎯 Event Management System
# Java Servlets | JSP | MariaDB | Apache Tomcat
 
# 📌 Project Overview
- The Event Management System is a Java-based web application that allows users to:
# View events
- Book events with slot-based control
# Cancel bookings
- Receive email confirmation on successful booking
# The application is built using 
- Java Servlets
- JSP
- DAO Pattern
- MariaDB
- it is following a clean MVC architecture, and is deployed on Apache Tomcat.
-----------------------------------------------------------------------------------------
# 🚀 Features
# Event Management
# Add new events with:
- Event Name
- Location
- Event Date
- Description
- Total Slots
- View all events in a dashboard
- Delete events with confirmation popup
# Event Booking
- Users can book an event by providing:
- Email ID
- Number of seats required
# On successful booking:
- Booking details are saved in the database
- Available slots are reduced automatically
- Confirmation email is sent to the user 📧
  # Booking Cancellation
- Users can cancel an existing booking
  # On cancellation:
  - Booked seats are released
  - Available slots are incremented automatically
  - Prevents slot blocking and ensures fair usage
# lot-Based Availability Control
- Each event has a fixed number of slots
- Slots decrease when a booking is made
- Slots increase when a booking is cancelled
- When available slots reach zero, further bookings are restricted
  # Booked Users Overview (Admin)
- Admin can view:
- Registered users for each event
- Number of seats booked by each user
- Booking time details
- Helps track event participation effectively
  # User Interface
- JSP-based modern UI
- Dark theme with gradient styling
- Clean forms and tables
- Simple and user-friendly navigation
  # Tech Stack
- Frontend: JSP, HTML, CSS
- Backend: Java Servlets
- Database: MariaDB / MySQL
- Architecture: MVC + DAO Pattern
- Server: Apache Tomcat 10+
- Build Tool: Maven
# 📸 Screenshots
- Event Dashboard
- Add Event Form
- Event Booking Form
- Slot Availability View
- Delete Confirmation
- Updated Events List
- (Screenshots are available in the screenshots/ folder)
# 📁 Project Folder Structure
----------------------------------------------------------------------------
EVENT-MANAGEMENT-SYSTEM/
- │
- ├── backend/
- │   ├── src/main/java/com/pms/
- │   │   ├── servlet/   (All Servlets)
- │   │   ├── model/     (Model Classes)
- │   │   └── dao/       (DAO Layer)
- │   │
- │   ├── src/main/webapp/
- │   │   ├── WEB-INF/views/ (JSP Pages)
- │   │   └── web.xml
- │   │
- │   └── pom.xml
- │
- ├── screenshots/
- └── README.md
--------------------------------------------------------------------------------------------
# 🗄 Database Schema (Implemented)
# events
- CREATE TABLE events (
  -    id INT PRIMARY KEY AUTO_INCREMENT,
  -   name VARCHAR(100) NOT NULL,
  -   location VARCHAR(100) NOT NULL,
  -    event_date DATE NOT NULL,
  -    description VARCHAR(255),
  -    slots INT NOT NULL
- );
------------------------------------
# bookings
- CREATE TABLE bookings (
    - id INT PRIMARY KEY AUTO_INCREMENT,
    -  event_id INT NOT NULL,
    - event_name VARCHAR(100) NOT NULL,
    - user_email VARCHAR(150) NOT NULL,
    - seats INT NOT NULL,
    - booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
- );
-------------------------------------------------------------
# users
- CREATE TABLE users (
   - id INT PRIMARY KEY AUTO_INCREMENT,
   - name VARCHAR(100),
   - email VARCHAR(100),
   - password VARCHAR(100)
- );
--------------------------------------------------
# ▶ How to Run This Project
- Install Java 17+
- Install Apache Tomcat 10+
- Install MariaDB / MySQL
- Create the database and tables using the schema above
- Open the project in VS Code / IntelliJ / Eclipse
- Run:
- mvn clean package
- Copy the generated .war file to:
- tomcat/webapps/
- Start Tomcat
- Open in browser:
- http://localhost:8080/backend/events
----------------------------------------------------------------
# 📄 License
-This project is developed for academic purposes at Galgotias University.
 
>>>>>>> 5b7ff224ce0bf46968bb8fc5093b52ee3ee5bf81
