package ru.cablemaster.entity;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class FeatureCoord {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private String geometryType;
    private String propertyId;
    private String propertyName;
    private String description;
    private String label;
    private String reserved;

    @OneToMany( cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<FeatureLonLat> geometryCoord  = new ArrayList<>();

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getGeometryType() {
        return geometryType;
    }

    public void setGeometryType(String geometryType) {
        this.geometryType = geometryType;
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

    public String getReserved() {
        return reserved;
    }

    public void setReserved(String reserved) {
        this.reserved = reserved;
    }

    public List<FeatureLonLat> getGeometryCoord() {
        return geometryCoord;
    }

    public void setGeometryCoord(List<FeatureLonLat> geometryCoord) {
        this.geometryCoord = geometryCoord;
    }
}

