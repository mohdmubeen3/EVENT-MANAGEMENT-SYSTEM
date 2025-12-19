package com.pms.config.model;

import java.time.LocalDate;

public class Event {

    private int id;
    private String name;
    private String location;
    private LocalDate eventDate;
    private String description;
    private int slots; // available slots

    public Event() {
    }

    public Event(int id, String name, String location,
                 LocalDate eventDate, String description, int slots) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.eventDate = eventDate;
        this.description = description;
        this.slots = slots;
    }

    // Getters & Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDate getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getSlots() {
        return slots;
    }

    public void setSlots(int slots) {
        this.slots = slots;
    }
}