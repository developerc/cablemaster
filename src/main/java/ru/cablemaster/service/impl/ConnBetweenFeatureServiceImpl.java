package ru.cablemaster.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.cablemaster.dao.ConnBetweenFeatureDao;
import ru.cablemaster.entity.ConnBetweenFeature;
import ru.cablemaster.service.ConnBetweenFeatureService;

import java.util.List;

@Service("connBetweenFeatureService")
public class ConnBetweenFeatureServiceImpl implements ConnBetweenFeatureService {
    @Autowired
    private ConnBetweenFeatureDao connBetweenFeatureDao;

    @Override
    public ConnBetweenFeature addConnBetweenFeature(ConnBetweenFeature connBetweenFeature) {
        return connBetweenFeatureDao.create(connBetweenFeature);
    }

    @Override
    public List<ConnBetweenFeature> getConnBetweenFeatures() {
        return connBetweenFeatureDao.getList();
    }

    @Override
    public ConnBetweenFeature getConnBetweenFeatureById(long id) {
        return connBetweenFeatureDao.getById(id);
    }

    @Override
    public ConnBetweenFeature deleteConnBetweenFeature(long id) {
        return connBetweenFeatureDao.delete(connBetweenFeatureDao.getById(id));
    }

    @Override
    public ConnBetweenFeature updConnBetweenFeature(ConnBetweenFeature connBetweenFeature) {
        return connBetweenFeatureDao.update(connBetweenFeature);
    }

    @Override
    public List<ConnBetweenFeature> getConnBetweenById(long id) {
        return connBetweenFeatureDao.getConnBetweenById(id);
    }
}
