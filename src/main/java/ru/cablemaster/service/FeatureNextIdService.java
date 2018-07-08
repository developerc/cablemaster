package ru.cablemaster.service;

import ru.cablemaster.entity.FeatureNextId;

import java.util.List;

public interface FeatureNextIdService {
    /**
     * method for add counter feature on the map
     *
     * @param featureNextId = new featureNextId for creation in DB
     * @return created featureNextId
     */
    FeatureNextId addFeatureNextId(FeatureNextId featureNextId);

    /**
     * method for receiving all counters of a features
     *
     * @return all FeatureNextIds
     */
    List<FeatureNextId> getAllFeatureNextIds();

    /**
     * method for receive specify featureNextId by id
     *
     * @param id = uniq FeatureNextId id
     * @return specify FeatureNextId by id
     */
    FeatureNextId getFeatureNextIdById(long id);

    /**
     * method for featureNextId delete
     *
     * @param id = FeatureNextId's id for delete
     * @return removed FeatureNextId
     */
    FeatureNextId deleteFeatureNextId(long id);

    /**
     * method for update featureLonLat
     *
     * @param featureNextId = update existing featureNextId in DB
     * @return updated featureNextId
     */
    FeatureNextId updFeatureNextId(FeatureNextId featureNextId);
}
