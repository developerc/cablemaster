package ru.cablemaster.service;

import ru.cablemaster.entity.FeatureLonLat;

import java.util.List;

public interface FeatureLonLatService {
    /**
     * method for add coordinates feature on the map
     *
     * @param featureLonLat = new featureLonLat for creation in DB
     * @return created featureLonLat
     */
    FeatureLonLat addFeatureLonLat(FeatureLonLat featureLonLat);

    /**
     * method for receiving all coordinates of a feature
     *
     * @return all FeatureLonLats
     */
    List<FeatureLonLat> getAllFeatureLonLats();

    /**
     * method for receive specify featureLonLat by id
     *
     * @param id = uniq FeatureLonLat id
     * @return specify FeatureLonLat by id
     */
    FeatureLonLat getFeatureLonLatById(long id);

    /**
     * method for eatureLonLat delete
     *
     * @param id = FeatureLonLat's id for delete
     * @return removed featureLonLat
     */
    FeatureLonLat deleteFeatureLonLat(long id);

    /**
     * method for update featureLonLat
     *
     * @param featureLonLat = update existing featureLonLat in DB
     * @return updated featureLonLat
     */
    FeatureLonLat updFeatureLonLat(FeatureLonLat featureLonLat);
}

