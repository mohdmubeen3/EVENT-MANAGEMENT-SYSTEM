<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.pms.config.model.Event" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    List<Event> events = (List<Event>) request.getAttribute("events");

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    String flashText = null;
    String flashType = null; // "success" or "error"

    if (success != null) {
        if ("added".equals(success)) {
            flashText = "Event added successfully.";
        } else if ("booked".equals(success)) {
            flashText = "Booking confirmed successfully.";
        }
        flashType = "success";
    } else if (error != null) {
        if ("add_failed".equals(error)) {
            flashText = "Failed to add event. Please try again.";
        } else if ("invalid_input".equals(error)) {
            flashText = "Invalid data provided. Please check your inputs.";
        } else if ("noslots".equals(error)) {
            flashText = "Booking failed. Not enough slots available for this event.";
        } else if ("server".equals(error) || "server_error".equals(error)) {
            flashText = "Server error occurred. Please try again later.";
        } else if ("invalid_event".equals(error) || "event_not_found".equals(error)) {
            flashText = "The selected event could not be found.";
        } else {
            flashText = "Something went wrong. Please try again.";
        }
        flashType = "error";
    }

    LocalDate today = LocalDate.now();
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy");

    // Build unique locations for location filter
    Set<String> locations = new HashSet<>();
    if (events != null) {
        for (Event e : events) {
            if (e.getLocation() != null) {
                locations.add(e.getLocation());
            }
        }
    }

    Integer totalEvents = (Integer) request.getAttribute("totalEvents");
    Integer totalSlots = (Integer) request.getAttribute("totalSlots");
    Integer soldOutEvents = (Integer) request.getAttribute("soldOutEvents");

    if (totalEvents == null) totalEvents = 0;
    if (totalSlots == null) totalSlots = 0;
    if (soldOutEvents == null) soldOutEvents = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Management System – Events</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        :root {
            --bg: #020617;
            --card: #020617;
            --accent: #38bdf8;
            --accent2: #22c55e;
            --accent-soft: rgba(56, 189, 248, 0.14);
            --text: #e5e7eb;
            --muted: #9ca3af;
            --danger: #f97373;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: system-ui, sans-serif;
            background: radial-gradient(circle at top, #1f2937 0, #020617 55%);
            color: var(--text);
            min-height: 100vh;
        }

        .nav {
            display: flex; justify-content: space-between; align-items: center;
            padding: 14px 30px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
            background: rgba(15, 23, 42, 0.9);
            position: sticky; top: 0; z-index: 20;
        }
        .nav-left-title { font-size: 1.1rem; font-weight: 600; color: var(--accent); }
        .nav-left-sub { font-size: 0.75rem; color: var(--muted); }
        .nav-right { display: flex; gap: 12px; align-items: center; }
        .nav-pill {
            font-size: 0.78rem; padding: 4px 10px; border-radius: 999px;
            border: 1px solid rgba(56, 189, 248, 0.45); background: rgba(15, 23, 42, 0.85);
            color: var(--muted);
        }
        .nav-pill span { color: var(--accent2); font-weight: 600; }
        .nav-links { display: flex; gap: 10px; }
        .nav-link {
            padding: 8px 14px; font-size: 0.85rem;
            border-radius: 999px; text-decoration: none;
            color: var(--muted); background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(148, 163, 184, 0.4);
            transition: 0.2s;
        }
        .nav-link:hover { color: #fff; border-color: var(--accent); }
        .nav-link-active {
            background: linear-gradient(to right, var(--accent), var(--accent2));
            color: #020617;
        }

        .wrapper { max-width: 1040px; margin: 30px auto; padding: 0 18px 32px; }
        .page-title { font-size: 1.8rem; font-weight: 600; }
        .page-subtitle { font-size: 0.9rem; color: var(--muted); margin-top: 4px; }

        .stats-bar {
            margin-top: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .stat-pill {
            font-size: 0.78rem;
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.45);
            background: rgba(15,23,42,0.9);
            color: var(--muted);
        }
        .stat-pill span {
            color: var(--accent2);
            font-weight: 600;
        }

        .card {
            background: rgba(15, 23, 42, 0.9);
            padding: 18px 20px; border-radius: 18px;
            border: 1px solid rgba(148,163,184,0.35);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 6px;
            border-radius: 12px;
            overflow: hidden;
        }
        th, td { padding: 8px 10px; border-bottom: 1px solid rgba(30, 64, 175, 0.55); }
        th { color: #cbd5f5; text-transform: uppercase; font-size: 0.8rem; }
        tbody tr:nth-child(even) { background: rgba(15, 23, 42, 0.80); }
        tbody tr:nth-child(odd) { background: rgba(15, 23, 42, 0.60); }

        .btn-primary {
            padding: 6px 12px; border-radius: 999px;
            text-decoration: none; font-size: 0.82rem;
            background: linear-gradient(to right, #0ea5e9, #22c55e);
            color: #0b1120; font-weight: 600;
        }
        .btn-danger {
            padding: 4px 10px; border-radius: 999px;
            text-decoration: none; font-size: 0.78rem;
            border: 1px solid rgba(248, 113, 113, 0.8);
            color: var(--danger);
        }

        .slots-ok { color: #4ade80; font-weight: 600; }
        .slots-zero { color: var(--danger); font-weight: 600; }

        .action-cell {
            display: flex;
            gap: 8px;
            align-items: center;
            justify-content: center;
            flex-wrap: nowrap;
        }
        .action-cell a {
            white-space: nowrap;
        }

        .flash {
            margin-top: 14px;
            margin-bottom: 10px;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .flash-success {
            background: rgba(34, 197, 94, 0.12);
            border: 1px solid rgba(34, 197, 94, 0.6);
            color: #bbf7d0;
        }
        .flash-error {
            background: rgba(248, 113, 113, 0.12);
            border: 1px solid rgba(248, 113, 113, 0.7);
            color: #fecaca;
        }

        .filters {
            margin: 16px 0 10px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        .filter-label {
            font-size: 0.8rem;
            color: var(--muted);
        }
        .filter-select,
        .filter-input {
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.55);
            background: rgba(15,23,42,0.9);
            color: var(--text);
            font-size: 0.85rem;
            outline: none;
        }
        .filter-input {
            min-width: 200px;
        }
        .filter-select:focus,
        .filter-input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 1px rgba(56,189,248,0.4);
        }
    </style>
</head>

<body>

<div class="nav">
    <div class="nav-left">
        <div class="nav-left-title">EVENT MANAGEMENT SYSTEM</div>
        <div class="nav-left-sub">Java · JSP · Servlets · MariaDB</div>
    </div>
    <div class="nav-right">
        <div class="nav-pill">Review-2: <span>Booking + Slots</span></div>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/events" class="nav-link nav-link-active">Events</a>
            <a href="<%= request.getContextPath() %>/add-event-form" class="nav-link">Add Event</a>
            <a href="<%= request.getContextPath() %>/bookings" class="nav-link">Bookings</a>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="page-title">All Events</div>
    <div class="page-subtitle">View and manage all events stored in the database.</div>

    <div class="stats-bar">
        <div class="stat-pill">Total Events: <span><%= totalEvents %></span></div>
        <div class="stat-pill">Total Slots (all events): <span><%= totalSlots %></span></div>
        <div class="stat-pill">Sold-out Events: <span><%= soldOutEvents %></span></div>
    </div>

    <% if (flashText != null && flashType != null) { %>
        <div class="flash <%= "success".equals(flashType) ? "flash-success" : "flash-error" %>">
            <span><%= flashText %></span>
        </div>
    <% } %>

    <!-- Filters -->
    <div class="filters">
        <span class="filter-label">Search event / location:</span>
        <input id="eventSearch"
               class="filter-input"
               type="text"
               placeholder="Type event name or location..."
               onkeyup="applyEventFilters()" />

        <span class="filter-label">Location:</span>
        <select id="locationFilter" class="filter-select" onchange="applyEventFilters()">
            <option value="ALL">All</option>
            <% for (String loc : locations) { %>
                <option value="<%= loc %>"><%= loc %></option>
            <% } %>
        </select>

        <span class="filter-label">Availability:</span>
        <select id="availabilityFilter" class="filter-select" onchange="applyEventFilters()">
            <option value="ALL">All</option>
            <option value="AVAILABLE">Available only</option>
            <option value="SOLDOUT">Sold out</option>
        </select>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Event Name</th>
                    <th>Location</th>
                    <th>Date</th>
                    <th>Slots</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                if (events == null || events.isEmpty()) {
            %>
            <tr>
                <td colspan="7" style="text-align:center; padding:20px;">No events found.</td>
            </tr>
            <%
                } else {
                    for (Event e : events) {
                        LocalDate d = e.getEventDate();

                        int slots = e.getSlots();
                        String slotsText = (slots > 0)
                                ? String.valueOf(slots)
                                : "Sold out";
                        String slotsClass = (slots > 0) ? "slots-ok" : "slots-zero";
            %>
            <tr class="event-row"
                data-name="<%= e.getName() %>"
                data-location="<%= e.getLocation() %>"
                data-slots="<%= slots %>">
                <td><%= e.getId() %></td>
                <td><%= e.getName() %></td>
                <td><%= e.getLocation() %></td>
                <td><%= d != null ? d.format(fmt) : "" %></td>

                <td class="<%= slotsClass %>"><%= slotsText %></td>

                <td><%= e.getDescription() %></td>

                <td class="action-cell">
                    <a href="<%= request.getContextPath() %>/book-event-form?id=<%= e.getId() %>"
                       class="btn-primary"
                       <%= (slots <= 0 ? "style='opacity:0.4;pointer-events:none;'" : "") %>>
                        Book
                    </a>

                    <a href="<%= request.getContextPath() %>/events/delete?id=<%= e.getId() %>"
                       class="btn-danger"
                       onclick="return confirm('Are you sure?');">
                        Delete
                    </a>
                </td>
            </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function applyEventFilters() {
        const searchTerm = document.getElementById('eventSearch').value.toLowerCase().trim();
        const locationValue = document.getElementById('locationFilter').value.toLowerCase();
        const availability = document.getElementById('availabilityFilter').value;

        const rows = document.querySelectorAll('tbody tr.event-row');

        rows.forEach(function (row) {
            const name = (row.getAttribute('data-name') || '').toLowerCase();
            const location = (row.getAttribute('data-location') || '').toLowerCase();
            const slotsStr = row.getAttribute('data-slots') || '0';
            const slots = parseInt(slotsStr, 10);

            const matchSearch =
                !searchTerm ||
                name.includes(searchTerm) ||
                location.includes(searchTerm);

            const matchLocation =
                (locationValue === 'all') ||
                (location === locationValue);

            let matchAvailability = true;
            if (availability === 'AVAILABLE') {
                matchAvailability = slots > 0;
            } else if (availability === 'SOLDOUT') {
                matchAvailability = slots <= 0;
            }

            row.style.display = (matchSearch && matchLocation && matchAvailability) ? '' : 'none';
        });
    }
</script>

</body>
</html>