package com.pms.config.model.dao;

import com.pms.config.DBConnection;
import com.pms.config.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // ================= BOOK EVENT (NO CHANGE) =================
    public boolean bookEvent(int eventId, String userName, String userEmail, int seats) throws SQLException {

        final String selectSlotsSql = "SELECT slots FROM events WHERE id = ? FOR UPDATE";
        final String insertBookingSql =
                "INSERT INTO bookings (event_id, user_name, user_email, seats) VALUES (?, ?, ?, ?)";
        final String updateSlotsSql =
                "UPDATE events SET slots = slots - ? WHERE id = ?";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int available;

            try (PreparedStatement ps = conn.prepareStatement(selectSlotsSql)) {
                ps.setInt(1, eventId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    available = rs.getInt("slots");
                }
            }

            if (available < seats) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setInt(1, eventId);
                ps.setString(2, userName);
                ps.setString(3, userEmail);
                ps.setInt(4, seats);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(updateSlotsSql)) {
                ps.setInt(1, seats);
                ps.setInt(2, eventId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // ================= FETCH BOOKINGS (FIXED) =================
    public List<Booking> getAllBookings() throws SQLException {

        final String sql =
            "SELECT b.id, b.event_id, e.name AS event_name, " +
            "b.user_name, b.user_email, b.seats, b.booking_time " +
            "FROM bookings b " +
            "JOIN events e ON b.event_id = e.id " +
            "ORDER BY b.booking_time DESC";

        List<Booking> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));
                b.setEventId(rs.getInt("event_id"));
                b.setEventName(rs.getString("event_name")); // 🔥 IMPORTANT
                b.setUserName(rs.getString("user_name"));
                b.setUserEmail(rs.getString("user_email"));
                b.setSeats(rs.getInt("seats"));

                Timestamp ts = rs.getTimestamp("booking_time");
                if (ts != null) {
                    b.setBookingTime(ts.toLocalDateTime());
                }

                list.add(b);
            }
        }

        return list;
    }

    // ================= CANCEL BOOKING (NO CHANGE) =================
   public boolean cancelBooking(int bookingId) throws SQLException {

    final String selectBookingSql =
            "SELECT event_id, seats FROM bookings WHERE id = ?";

    final String deleteBookingSql =
            "DELETE FROM bookings WHERE id = ?";

    final String updateSlotsSql =
            "UPDATE events SET slots = slots + ? WHERE id = ?";

    Connection conn = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); // START TRANSACTION

        int eventId;
        int seats;

        // 1️⃣ Fetch booking details
        try (PreparedStatement psSelect = conn.prepareStatement(selectBookingSql)) {
            psSelect.setInt(1, bookingId);
            try (ResultSet rs = psSelect.executeQuery()) {
                if (!rs.next()) {
                    conn.rollback();
                    return false; // booking not found
                }
                eventId = rs.getInt("event_id");
                seats = rs.getInt("seats");
            }
        }

        // 2️⃣ Delete booking
        try (PreparedStatement psDelete = conn.prepareStatement(deleteBookingSql)) {
            psDelete.setInt(1, bookingId);
            psDelete.executeUpdate();
        }

        // 3️⃣ Restore slots
        try (PreparedStatement psUpdate = conn.prepareStatement(updateSlotsSql)) {
            psUpdate.setInt(1, seats);
            psUpdate.setInt(2, eventId);
            psUpdate.executeUpdate();
        }

        conn.commit(); // ✅ SUCCESS
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

}
