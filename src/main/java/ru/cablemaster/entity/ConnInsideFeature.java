package ru.cablemaster.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class ConnInsideFeature {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private long connectedTo;
    private String propertyId;
    private String colorThread;
    private String description;
    private String label;
    private String reserved;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getConnectedTo() {
        return connectedTo;
    }

    public void setConnectedTo(long connectedTo) {
        this.connectedTo = connectedTo;
    }

    public String getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(String propertyId) {
        this.propertyId = propertyId;
    }

    public String getColorThread() {
        return colorThread;
    }

    public void setColorThread(String colorThread) {
        this.colorThread = colorThread;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getReserved() {
        return reserved;
    }

    public void setReserved(String reserved) {
        this.reserved = reserved;
    }
}
