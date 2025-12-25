package com.pms.config.model.dao;

import com.pms.config.DBConnection;
import com.pms.config.model.Event;

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

        String sql = "SELECT id, name, location, event_date, description, slots FROM events";

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
                event.setSlots(rs.getInt("slots"));

                events.add(event);
            }
        }

        return events;
    }

    // Insert a new event into DB
    public void addEvent(Event event) throws SQLException {
        String sql = "INSERT INTO events (name, location, event_date, description, slots) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, event.getName());
            stmt.setString(2, event.getLocation());
            stmt.setDate(3, Date.valueOf(event.getEventDate()));
            stmt.setString(4, event.getDescription());
            stmt.setInt(5, event.getSlots());

            stmt.executeUpdate();
        }
    }

    // Delete an event by id
    public void deleteEvent(int id) throws SQLException {
        String sql = "DELETE FROM events WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // 🔴 NEW: fetch single event by id (for email details)
    public Event getEventById(int id) throws SQLException {
        String sql = "SELECT id, name, location, event_date, description, slots FROM events WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Event event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setName(rs.getString("name"));
                    event.setLocation(rs.getString("location"));

                    Date date = rs.getDate("event_date");
                    if (date != null) {
                        event.setEventDate(date.toLocalDate());
                    }

                    event.setDescription(rs.getString("description"));
                    event.setSlots(rs.getInt("slots"));
                    return event;
                }
            }
        }

        return null; // not found
    }
}