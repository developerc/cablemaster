package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.ConnInsideFeatureDao;
import ru.cablemaster.entity.ConnInsideFeature;

import javax.persistence.Query;
import java.util.List;

public class ConnInsideFeatureDaoImpl extends BasicDaoImpl<ConnInsideFeature> implements ConnInsideFeatureDao {
    public ConnInsideFeatureDaoImpl(Class<ConnInsideFeature> entityClass) {
        super(entityClass);
    }

    @Override
    public List<ConnInsideFeature> getConnInsideFeatureByPropertyId(String propertyId) {
        Query query = getSessionFactory().createQuery("SELECT a FROM ConnInsideFeature as a WHERE a.propertyId = :propertyId");
        query.setParameter("propertyId", propertyId);
        return query.getResultList();
    }
}
