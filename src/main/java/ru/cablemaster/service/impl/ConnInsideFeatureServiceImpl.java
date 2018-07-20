package ru.cablemaster.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.cablemaster.dao.ConnInsideFeatureDao;
import ru.cablemaster.entity.ConnInsideFeature;
import ru.cablemaster.service.ConnInsideFeatureService;

import java.util.List;

@Service("connInsideFeatureService")
public class ConnInsideFeatureServiceImpl implements ConnInsideFeatureService{
    @Autowired
    private ConnInsideFeatureDao connInsideFeatureDao;

    @Override
    public ConnInsideFeature addConnInsideFeature(ConnInsideFeature connInsideFeature) {
        return connInsideFeatureDao.create(connInsideFeature);
    }

    @Override
    public List<ConnInsideFeature> getConnInsideFeatures() {
        return connInsideFeatureDao.getList();
    }

    @Override
    public ConnInsideFeature getConnInsideFeatureById(long id) {
        return connInsideFeatureDao.getById(id);
    }

    @Override
    public ConnInsideFeature deleteConnInsideFeature(long id) {
        return connInsideFeatureDao.delete(connInsideFeatureDao.getById(id));
    }

    @Override
    public ConnInsideFeature updConnInsideFeature(ConnInsideFeature connInsideFeature) {
        return connInsideFeatureDao.update(connInsideFeature);
    }

    @Override
    public List<ConnInsideFeature> getConnInsideFeatureByPropertyId(String propertyId) {
        return connInsideFeatureDao.getConnInsideFeatureByPropertyId(propertyId);
    }
}
