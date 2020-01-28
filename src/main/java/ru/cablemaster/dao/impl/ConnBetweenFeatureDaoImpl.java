package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.ConnBetweenFeatureDao;
import ru.cablemaster.entity.ConnBetweenFeature;

import javax.persistence.Query;
import java.util.List;

public class ConnBetweenFeatureDaoImpl extends BasicDaoImpl<ConnBetweenFeature> implements ConnBetweenFeatureDao {
    public ConnBetweenFeatureDaoImpl(Class<ConnBetweenFeature> entityClass) {
        super(entityClass);
    }

    @Override
    public List<ConnBetweenFeature> getConnBetweenById(long id) {
        Query query = getSessionFactory().createQuery("SELECT a FROM ConnBetweenFeature as a WHERE (a.connId1 = :Id or a.connId2 = :Id)");
        query.setParameter("Id", id);
        return query.getResultList();
    }

    @Override
    public List<ConnBetweenFeature> getByDescription(String descr) {
        Query query = getSessionFactory().createQuery("from ConnBetweenFeature  where description = :descr");
        query.setParameter("descr", descr);
        return query.getResultList();
    }
}
