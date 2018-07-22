package ru.cablemaster.service;

import ru.cablemaster.entity.ConnInsideFeature;

import java.util.List;

public interface ConnInsideFeatureService {
    /**
     * method for add connection inside feature to base
     *
     * @param connInsideFeature = new connInsideFeature for creation in DB
     * @return created connInsideFeature
     */
    ConnInsideFeature addConnInsideFeature(ConnInsideFeature connInsideFeature);

    /**
     * method for receiving all ConnInsideFeatures
     *
     * @return all ConnInsideFeature
     */
    List<ConnInsideFeature> getConnInsideFeatures();

    /**
     * method for receive specify ConnInsideFeature by id
     *
     * @param id = uniq ConnInsideFeature id
     * @return specify ConnInsideFeature by id
     */
    ConnInsideFeature getConnInsideFeatureById(long id);

    /**
     * method for ConnInsideFeature delete
     *
     * @param id = ConnInsideFeature's id for delete
     * @return removed ConnInsideFeature
     */
    ConnInsideFeature deleteConnInsideFeature(long id);

    /**
     * method for update connInsideFeature
     *
     * @param connInsideFeature = update existing connInsideFeature in DB
     * @return updated connInsideFeature
     */
    ConnInsideFeature updConnInsideFeature(ConnInsideFeature connInsideFeature);

    /**
     * method for finding ConnInsideFeature by propertyId
     *@param propertyId = propertyId of ConnInsideFeature
     *@return list ConnInsideFeature with success parameters
     * **/
    List<ConnInsideFeature> getConnInsideFeatureByPropertyId(String propertyId);

    /**
     * method for deleting ConnInsideFeature by propertyId
     * @param propertyId = propertyId of ConnInsideFeature
     * @return List ConnInsideFeature success deleting ConnInsideFeature
     * **/
    List<ConnInsideFeature> delConnInsideFeatureByPropertyId(String propertyId);
}
