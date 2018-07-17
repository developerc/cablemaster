package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.ConnInsideFeatureDao;
import ru.cablemaster.entity.ConnInsideFeature;

public class ConnInsideFeatureDaoImpl extends BasicDaoImpl<ConnInsideFeature> implements ConnInsideFeatureDao {
    public ConnInsideFeatureDaoImpl(Class<ConnInsideFeature> entityClass) {
        super(entityClass);
    }
}
