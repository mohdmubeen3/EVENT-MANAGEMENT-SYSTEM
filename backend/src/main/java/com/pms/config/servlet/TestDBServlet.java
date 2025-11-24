package com.pms.config.servlet;

import com.pms.config.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        try (Connection conn = DBConnection.getConnection()) {

            // Insert a dummy user every time (just for testing)
            String insertSql = "INSERT INTO users(name, email, password) VALUES (?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, "Mubeen");
                ps.setString(2, "mubeen@test.com");
                ps.setString(3, "1234");
                ps.executeUpdate();
            }

            // Now fetch all users
            String selectSql = "SELECT id, name, email FROM users";
            try (PreparedStatement ps = conn.prepareStatement(selectSql);
                 ResultSet rs = ps.executeQuery()) {

                out.println("Users table data:");
                out.println("-----------------");
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    out.println(id + " | " + name + " | " + email);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }
}