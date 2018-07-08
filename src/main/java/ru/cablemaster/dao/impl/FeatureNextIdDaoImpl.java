package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.FeatureNextIdDao;
import ru.cablemaster.entity.FeatureNextId;

public class FeatureNextIdDaoImpl extends BasicDaoImpl<FeatureNextId> implements FeatureNextIdDao {
    public FeatureNextIdDaoImpl(Class<FeatureNextId> entityClass) {
        super(entityClass);
    }
}
