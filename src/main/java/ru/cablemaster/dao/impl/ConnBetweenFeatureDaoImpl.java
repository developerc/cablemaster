package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.ConnBetweenFeatureDao;
import ru.cablemaster.entity.ConnBetweenFeature;

public class ConnBetweenFeatureDaoImpl extends BasicDaoImpl<ConnBetweenFeature> implements ConnBetweenFeatureDao {
    public ConnBetweenFeatureDaoImpl(Class<ConnBetweenFeature> entityClass) {
        super(entityClass);
    }
}
