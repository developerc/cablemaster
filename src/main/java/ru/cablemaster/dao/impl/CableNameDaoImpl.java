package ru.cablemaster.dao.impl;

import ru.cablemaster.dao.CableNameDao;
import ru.cablemaster.entity.CableName;

public class CableNameDaoImpl extends BasicDaoImpl<CableName> implements CableNameDao {
    public CableNameDaoImpl(Class<CableName> entityClass) {
        super(entityClass);
    }

}
