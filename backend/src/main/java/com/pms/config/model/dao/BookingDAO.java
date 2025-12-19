package com.pms.config.model.dao;

import com.pms.config.DBConnection;
import com.pms.config.model.Booking;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * BookingDAO - handles booking related DB operations.
 * Includes:
 *  • Atomic booking transaction (check availability + insert booking + update slots)
 *  • Fetch all bookings
 *  • Cancel a booking
 */
public class BookingDAO {

    /**
     * Booking method with email required.
     */
    public boolean bookEvent(int eventId, String userName, String userEmail, int seats) throws SQLException {

        final String selectSlotsSql = "SELECT slots FROM events WHERE id = ? FOR UPDATE";
        final String insertBookingSql =
                "INSERT INTO bookings (event_id, user_name, user_email, seats) VALUES (?, ?, ?, ?)";
        final String updateSlotsSql =
                "UPDATE events SET slots = slots - ? WHERE id = ?";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // START TRANSACTION

            // 1) Check available seats
            int available = 0;
            try (PreparedStatement psSelect = conn.prepareStatement(selectSlotsSql)) {
                psSelect.setInt(1, eventId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false; // event not found
                    }
                    available = rs.getInt("slots");
                }
            }

            if (available < seats) {
                conn.rollback();
                return false; // not enough seats
            }

            // 2) Insert booking
            try (PreparedStatement psInsert = conn.prepareStatement(insertBookingSql)) {
                psInsert.setInt(1, eventId);
                psInsert.setString(2, userName);
                psInsert.setString(3, userEmail);
                psInsert.setInt(4, seats);
                psInsert.executeUpdate();
            }

            // 3) Reduce slots
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSlotsSql)) {
                psUpdate.setInt(1, seats);
                psUpdate.setInt(2, eventId);
                psUpdate.executeUpdate();
            }

            conn.commit();  // SUCCESS
            return true;

        } catch (SQLException e) {

            if (conn != null) conn.rollback();
            throw e;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }


    /**
     * Overloaded method (without email)
     */
    public boolean bookEvent(int eventId, String userName, int seats) throws SQLException {
        return bookEvent(eventId, userName, "", seats);
    }


    /**
     * Fetch ALL bookings for Listing Page, Export CSV, Dashboard stats, etc.
     */
    public List<Booking> getAllBookings() throws SQLException {
        final String sql =
                "SELECT id, event_id, user_name, user_email, seats, booking_time " +
                "FROM bookings ORDER BY booking_time DESC";

        List<Booking> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));
                b.setEventId(rs.getInt("event_id"));
                b.setUserName(rs.getString("user_name"));
                b.setUserEmail(rs.getString("user_email"));
                b.setSeats(rs.getInt("seats"));

                Timestamp ts = rs.getTimestamp("booking_time");
                if (ts != null) b.setBookingTime(ts.toLocalDateTime());

                list.add(b);
            }
        }

        return list;
    }


    /**
     * Cancel a booking by ID.
     */
    public boolean cancelBooking(int bookingId) throws SQLException {
        final String sql = "DELETE FROM bookings WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

}