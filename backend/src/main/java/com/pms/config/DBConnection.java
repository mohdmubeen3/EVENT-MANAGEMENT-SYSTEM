package com.pms.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mariadb://localhost:3306/event_management";
    private static final String USER = "root";
    private static final String PASSWORD = "Admin@123"; // <-- put your real password

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MariaDB Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}