package ru.cablemaster.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.cablemaster.dao.CableNameDao;
import ru.cablemaster.entity.CableName;
import ru.cablemaster.service.CableNameService;

import java.util.List;

@Service("cableNameService")
public class CableNameServiceImpl implements CableNameService {
    @Autowired
    private CableNameDao cableNameDao;

    @Override
    public CableName addCableName(CableName cableName) {
        return cableNameDao.create(cableName);
    }

    @Override
    public List<CableName> getAllCableNames() {
        return cableNameDao.getList();
    }

    @Override
    public CableName getCableNameById(long id) {
        return cableNameDao.getById(id);
    }

    @Override
    public CableName deleteCableName(long id) {
        return cableNameDao.delete(cableNameDao.getById(id));
    }

    @Override
    public CableName updCableName(CableName cableName) {
        return cableNameDao.update(cableName);
    }
}
