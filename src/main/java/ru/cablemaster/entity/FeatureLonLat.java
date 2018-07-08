package ru.cablemaster.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class FeatureLonLat {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private double longitude;
    private double latitude;
    private String propertyId;
    private String propertyName;
    private String description;
    private String label;
    private boolean featureBegin;
    private boolean featureEnd;
    private String reserved;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public String getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(String propertyId) {
        this.propertyId = propertyId;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
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

    public boolean isFeatureBegin() {
        return featureBegin;
    }

    public void setFeatureBegin(boolean featureBegin) {
        this.featureBegin = featureBegin;
    }

    public boolean isFeatureEnd() {
        return featureEnd;
    }

    public void setFeatureEnd(boolean featureEnd) {
        this.featureEnd = featureEnd;
    }

    public String getReserved() {
        return reserved;
    }

    public void setReserved(String reserved) {
        this.reserved = reserved;
    }
}

