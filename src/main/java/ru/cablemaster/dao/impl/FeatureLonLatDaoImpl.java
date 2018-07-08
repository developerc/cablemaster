package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.FeatureLonLatDao;
import ru.cablemaster.entity.FeatureLonLat;

public class FeatureLonLatDaoImpl extends BasicDaoImpl<FeatureLonLat> implements FeatureLonLatDao {
    public FeatureLonLatDaoImpl(Class<FeatureLonLat> entityClass) {
        super(entityClass);
    }
}
