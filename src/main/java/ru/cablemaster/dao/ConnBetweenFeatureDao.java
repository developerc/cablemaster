package ru.cablemaster.dao;

import ru.cablemaster.entity.ConnBetweenFeature;

import java.util.List;

public interface ConnBetweenFeatureDao extends BasicDao<ConnBetweenFeature>{
    /**
     * method for finding List ConnBetweenFeature by connId1 or connId2
     *@param id = connId1 or connId2 of ConnBetweenFeature
     *@return List ConnBetweenFeature  with success parameters
     * **/
    List<ConnBetweenFeature> getConnBetweenById(long id);
}
