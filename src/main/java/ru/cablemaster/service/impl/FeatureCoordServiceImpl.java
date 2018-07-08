package ru.cablemaster.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.cablemaster.dao.FeatureCoordDao;
import ru.cablemaster.entity.FeatureCoord;
import ru.cablemaster.service.FeatureCoordService;

import java.util.List;

@Service("featureCoordService")
public class FeatureCoordServiceImpl implements FeatureCoordService{
    @Autowired
    private FeatureCoordDao featureCoordDao;

    @Override
    public FeatureCoord addFeatureCoord(FeatureCoord featureCoord) {
        return featureCoordDao.create(featureCoord);
    }

    @Override
    public List<FeatureCoord> getAllFeatureCoords() {
        return featureCoordDao.getList();
    }

    @Override
    public FeatureCoord getFeatureCoordById(long id) {
        return featureCoordDao.getById(id);
    }

    @Override
    public FeatureCoord deleteFeatureCoord(long id) {
        return featureCoordDao.delete(featureCoordDao.getById(id));
    }

    @Override
    public FeatureCoord updFeatureCoord(FeatureCoord featureCoord) {
        return featureCoordDao.update(featureCoord);
    }

    @Override
    public List<FeatureCoord> getFeatureCoordByPropertyId(String propertyId) {
        return featureCoordDao.getFeatureCoordByPropertyId(propertyId);
    }

    @Override
    public List<FeatureCoord> delFeatureCoordByPropertyId(String propertyId) {
        return featureCoordDao.delFeatureCoordByPropertyId(propertyId);
    }

    /*@Override
    public FeatureCoord delFeatureCoordByPropertyId(String propertyId) {
        return featureCoordDao.delete(featureCoordDao.getFeatureCoordByPropertyId(propertyId));
    }*/
}

