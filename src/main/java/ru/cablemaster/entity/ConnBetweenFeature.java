package ru.cablemaster.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class ConnBetweenFeature {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private long connId1;
    private long connId2;
    private String description;
    private String reserved;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getConnId1() {
        return connId1;
    }

    public void setConnId1(long connId1) {
        this.connId1 = connId1;
    }

    public long getConnId2() {
        return connId2;
    }

    public void setConnId2(long connId2) {
        this.connId2 = connId2;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReserved() {
        return reserved;
    }

    public void setReserved(String reserved) {
        this.reserved = reserved;
    }
}
