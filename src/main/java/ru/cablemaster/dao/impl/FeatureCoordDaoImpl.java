package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.FeatureCoordDao;
import ru.cablemaster.entity.FeatureCoord;

import javax.persistence.Query;
import java.util.List;

public class FeatureCoordDaoImpl extends BasicDaoImpl<FeatureCoord> implements FeatureCoordDao {
    public FeatureCoordDaoImpl(Class<FeatureCoord> entityClass) {
        super(entityClass);
    }

    @Override
    public List<FeatureCoord> getFeatureCoordByPropertyId(String propertyId) {
        Query query = getSessionFactory().createQuery("SELECT a FROM FeatureCoord as a WHERE a.propertyId = :propertyId");
        query.setParameter("propertyId", propertyId);
        return query.getResultList();
    }

    @Override
    public List<FeatureCoord> delFeatureCoordByPropertyId(String propertyId) {
        //return (List<FeatureCoord>) getSessionFactory().createQuery("delete from FeatureCoord where propertyId = ?").setParameter(0, propertyId);
        Query query = getSessionFactory().createQuery("delete from FeatureCoord where propertyId = :propertyId");
        query.setParameter("propertyId", propertyId);
        return query.getResultList();
    }

    /*@Override
    public FeatureCoord delFeatureCoordByPropertyId(String propertyId) {
        Query query = getSessionFactory().createQuery("DELETE FROM FeatureCoord  WHERE propertyId = :propertyId");
        query.setParameter("propertyId", propertyId);
        return (FeatureCoord)query.getSingleResult();
    }*/
}

