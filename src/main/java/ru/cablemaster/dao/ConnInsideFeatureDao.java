package ru.cablemaster.dao;

import ru.cablemaster.entity.ConnInsideFeature;

import java.util.List;

public interface ConnInsideFeatureDao extends BasicDao<ConnInsideFeature>{
    /**
     * method for finding ConnInsideFeature by propertyId
     *@param propertyId = propertyId of ConnInsideFeature
     *@return list ConnInsideFeature with success parameters
     * **/
    List<ConnInsideFeature> getConnInsideFeatureByPropertyId(String propertyId);

    /**
     * method for deleting ConnInsideFeature by propertyId
     * @param propertyId = propertyId of ConnInsideFeature
     * @return List success deleting ConnInsideFeature
     * **/
    List<ConnInsideFeature> delConnInsideFeatureByPropertyId(String propertyId);
}
