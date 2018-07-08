package ru.cablemaster.dao;

import ru.cablemaster.entity.FeatureCoord;

import java.util.List;

public interface FeatureCoordDao extends BasicDao<FeatureCoord> {

    /**
     * method for finding featureCoord by propertyId
     *@param propertyId = propertyId of featureCoord
     *@return list featureCoord with success parameters
     * **/
    List<FeatureCoord> getFeatureCoordByPropertyId(String propertyId);

    /**
     * method for deleting featureCoord by propertyId
     * @param propertyId = propertyId of featureCoord
     * @return true if success deleting
     * **/
    List<FeatureCoord> delFeatureCoordByPropertyId(String propertyId);
}

