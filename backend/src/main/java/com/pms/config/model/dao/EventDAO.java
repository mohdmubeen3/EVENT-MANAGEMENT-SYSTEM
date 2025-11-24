package com.pms.config.model.dao;

import com.pms.config.model.Event;
import com.pms.config.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    // Get all events
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();

        String sql = "SELECT id, name, location, event_date, description FROM events";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Event event = new Event();
                event.setId(rs.getInt("id"));
                event.setName(rs.getString("name"));
                event.setLocation(rs.getString("location"));

                Date date = rs.getDate("event_date");
                if (date != null) {
                    event.setEventDate(date.toLocalDate());
                }

                event.setDescription(rs.getString("description"));
                events.add(event);
            }
        }

        return events;
    }

    // Insert a new event into DB
    public void addEvent(Event event) throws SQLException {
        String sql = "INSERT INTO events (name, location, event_date, description) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, event.getName());
            stmt.setString(2, event.getLocation());
            // LocalDate -> java.sql.Date
            stmt.setDate(3, Date.valueOf(event.getEventDate()));
            stmt.setString(4, event.getDescription());

            stmt.executeUpdate();
        }
    }

    // 🔴 NEW: Delete an event by id
    public void deleteEvent(int id) throws SQLException {
        String sql = "DELETE FROM events WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}