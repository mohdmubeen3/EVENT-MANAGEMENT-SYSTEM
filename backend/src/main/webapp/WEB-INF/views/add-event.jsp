<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // No cache – always load fresh UI
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    java.time.LocalDate today = java.time.LocalDate.now();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Event – Event Management System</title>
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
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: radial-gradient(circle at top, #1f2937 0, #020617 55%);
            color: var(--text);
            min-height: 100vh;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 30px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
            background: linear-gradient(to right, rgba(15, 23, 42, 0.96), rgba(15, 23, 42, 0.9));
            backdrop-filter: blur(14px);
        }

        .nav-left-title {
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: var(--accent);
        }

        .nav-left-sub {
            font-size: 0.75rem;
            color: var(--muted);
        }

        .nav-left {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .nav-right {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .nav-links {
            display: flex;
            gap: 10px;
        }

        .nav-link {
            padding: 8px 14px;
            font-size: 0.85rem;
            border-radius: 999px;
            border: 1px solid rgba(148, 163, 184, 0.4);
            color: var(--muted);
            text-decoration: none;
            background: rgba(15, 23, 42, 0.6);
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            color: #ffffff;
            border-color: rgba(56, 189, 248, 0.6);
            box-shadow: 0 0 14px rgba(56, 189, 248, 0.7);
            transform: translateY(-2px);
        }

        .nav-link-active {
            background: linear-gradient(to right, var(--accent), var(--accent2));
            color: #020617;
            border-color: transparent;
            box-shadow: 0 0 18px rgba(56, 189, 248, 0.9);
            font-weight: 600;
        }

        .wrapper {
            max-width: 720px;
            margin: 32px auto 40px;
            padding: 0 18px 32px;
        }

        .card {
            background: radial-gradient(circle at top left, rgba(56, 189, 248, 0.16), transparent 60%),
                        radial-gradient(circle at bottom, rgba(15, 23, 42, 0.96), #020617 75%);
            border-radius: 18px;
            padding: 22px 22px 24px;
            border: 1px solid rgba(148, 163, 184, 0.35);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.9);
        }

        .form-title {
            font-size: 1.7rem;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .form-subtitle {
            font-size: 0.9rem;
            color: var(--muted);
            margin-bottom: 18px;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;
            margin-bottom: 4px;
            font-size: 0.9rem;
            color: #cbd5f5;
        }

        .input, .textarea {
            width: 100%;
            padding: 9px 11px;
            border-radius: 10px;
            border: 1px solid rgba(148, 163, 184, 0.6);
            background: rgba(15, 23, 42, 0.9);
            color: var(--text);
            font-size: 0.9rem;
            outline: none;
        }

        .input:focus, .textarea:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 1px rgba(56, 189, 248, 0.5);
        }

        .textarea {
            min-height: 90px;
            resize: vertical;
        }

        .btn-row {
            margin-top: 12px;
            display: flex;
            gap: 10px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 9px 18px;
            font-size: 0.9rem;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.16s ease;
        }

        .btn-primary {
            background: linear-gradient(to right, #0ea5e9, #22c55e);
            color: #0b1120;
            font-weight: 600;
            box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.25);
            flex: 1;
        }

        .btn-primary:hover {
            filter: brightness(1.05);
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(8, 47, 73, 0.8);
        }

        .btn-secondary {
            background: transparent;
            color: var(--muted);
            border-color: rgba(148, 163, 184, 0.6);
            padding-inline: 14px;
        }

        .btn-secondary:hover {
            background: rgba(148, 163, 184, 0.09);
        }

        @media (max-width: 720px) {
            .nav {
                padding: 10px 16px;
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
            }

            .wrapper {
                margin-top: 22px;
            }

            .btn-row {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="nav">
    <div class="nav-left">
        <div class="nav-left-title">EVENT MANAGEMENT SYSTEM</div>
        <div class="nav-left-sub">Add New Event · Java · JSP · Servlets</div>
    </div>
    <div class="nav-right">
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/events"
               class="nav-link">Events</a>
            <a href="<%= request.getContextPath() %>/add-event-form"
               class="nav-link nav-link-active">Add Event</a>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="card">
        <div class="form-title">Add New Event</div>
        <div class="form-subtitle">
            Fill in the details below to create a new event in the system.
        </div>

        <form action="<%= request.getContextPath() %>/add-event" method="post">
            <div class="form-group">
                <label for="name">Name</label>
                <input class="input" type="text" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="location">Location</label>
                <input class="input" type="text" id="location" name="location" required>
            </div>

            <div class="form-group">
                <label for="eventDate">Date</label>
                <input class="input" type="date" id="eventDate" name="eventDate"
                       value="<%= today.toString() %>" required>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea class="textarea" id="description" name="description"
                          placeholder="Short summary of the event..." required></textarea>
            </div>

            <!-- ✅ NEW: Slots field -->
            <div class="form-group">
                <label for="slots">Number of Slots</label>
                <input class="input" type="number" id="slots" name="slots" min="1" required
                       placeholder="Total seats available for this event">
            </div>

            <div class="btn-row">
                <button type="submit" class="btn btn-primary">Save Event</button>
                <a href="<%= request.getContextPath() %>/events" class="btn btn-secondary">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

</body>
</html>