# 🎯 Event Management System  
### Java Servlets + JSP + MariaDB | Semester 3 Project (B.Tech CSE AI–ML)

The **Event Management System** is a simple and efficient CRUD web application built using:  
- **Java Servlets (Backend Logic)**  
- **JSP (Frontend Rendering)**  
- **DAO Pattern (Database Operations)**  
- **MariaDB / MySQL (Database Storage)**  
- **Apache Tomcat (Server Deployment)**  

This project allows users to **Add, View, and Delete** events in a structured and visually modern interface.

---

## 🚀 Features

### ✅ Add Event  
Fill out a form to create a new event with details like:
- Event Name  
- Location  
- Date  
- Description  

### ✅ View Events  
Shows all events from the database in a clean UI table.

### ✅ Delete Event  
Delete any event with a confirmation popup.

### 🎨 Modern UI  
- Fully redesigned premium UI using JSP + CSS  
- Dark theme with gradients  
- Smooth buttons & modern cards

---

## 🛠️ Tech Stack

| Component | Technology |
|----------|------------|
| Frontend | JSP + HTML + CSS |
| Backend | Java Servlets |
| Database | MariaDB / MySQL |
| Pattern Used | DAO (Data Access Object) |
| Server | Apache Tomcat 10+ |
| Build Tool | Maven |

---

## 📁 Project Folder Structure

```
EVENT-MANAGEMENT-SYSTEM/
│
├── backend/
│   ├── src/main/java/com/pms/config/
│   │   ├── servlet/ (All Servlets)
│   │   ├── model/   (Event Model)
│   │   └── dao/     (EventDAO)
│   ├── src/main/webapp/
│   │   ├── WEB-INF/views/ (JSP Pages)
│   │   └── web.xml
│   └── pom.xml (Maven configuration)
│
└── README.md
```

---

## 🗄️ Database Schema (MariaDB)

```sql
CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    location VARCHAR(255),
    eventDate DATE,
    description TEXT
);
```

---

## ▶️ How to Run This Project

1. Install **Java 17+**
2. Install **Apache Tomcat 10+**
3. Install **MariaDB / MySQL**
4. Import the SQL table shown above
5. Open the project in **VS Code / IntelliJ / Eclipse**
6. Run Maven:
   ```
   mvn clean package
   ```
7. Copy WAR file to Tomcat `webapps/`
8. Start Tomcat
9. Open in browser:
   ```
   http://localhost:8080/backend/events
   ```
---

## 📄 License  
This project is created for academic purposes at **Galgotias University**.

---

✨ _Thank you for checking out the project!_
