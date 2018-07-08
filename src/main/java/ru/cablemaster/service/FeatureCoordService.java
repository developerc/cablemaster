package ru.cablemaster.service;

import ru.cablemaster.entity.FeatureCoord;

import java.util.List;

public interface FeatureCoordService {
    /**
     * method for add featureCoord
     *
     * @param featureCoord = new feature with coordinates for creation in DB
     * @return created featureCoord
     */
    FeatureCoord addFeatureCoord(FeatureCoord featureCoord);

    /**
     * method for receiving all featureCoord
     *
     * @return all featureCoord
     */
    List<FeatureCoord> getAllFeatureCoords();

    /**
     * method for receive specify featureCoord by id
     *
     * @param id = uniq featureCoord id
     * @return specify featureCoord by id
     */
    FeatureCoord getFeatureCoordById(long id);

    /**
     * method for featureCoord delete
     *
     * @param id = featureCoord's id for delete
     * @return removed featureCoord
     */
    FeatureCoord deleteFeatureCoord(long id);

    /**
     * method for update featureCoord
     *
     * @param featureCoord = update existing featureCoord in DB
     * @return updated featureCoord
     */
    FeatureCoord updFeatureCoord(FeatureCoord featureCoord);

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

