package ru.cablemaster.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.cablemaster.dao.FeatureNextIdDao;
import ru.cablemaster.entity.FeatureNextId;
import ru.cablemaster.service.FeatureNextIdService;

import java.util.List;

@Service("featureNextIdService")
public class FeatureNextIdServiceImpl implements FeatureNextIdService {
    @Autowired
    private FeatureNextIdDao featureNextIdDao;

    @Override
    public FeatureNextId addFeatureNextId(FeatureNextId featureNextId) {
        return featureNextIdDao.create(featureNextId);
    }

    @Override
    public List<FeatureNextId> getAllFeatureNextIds() {
        return featureNextIdDao.getList();
    }

    @Override
    public FeatureNextId getFeatureNextIdById(long id) {
        return featureNextIdDao.getById(id);
    }

    @Override
    public FeatureNextId deleteFeatureNextId(long id) {
        return featureNextIdDao.delete(featureNextIdDao.getById(id));
    }

    @Override
    public FeatureNextId updFeatureNextId(FeatureNextId featureNextId) {
        return featureNextIdDao.update(featureNextId);
    }
}
