package ru.cablemaster.service;

import ru.cablemaster.entity.ConnBetweenFeature;

import java.util.List;

public interface ConnBetweenFeatureService {
    /**
     * method for add connection between features to base
     *
     * @param connBetweenFeature = new ConnBetweenFeature for creation in DB
     * @return created ConnBetweenFeature
     */
    ConnBetweenFeature addConnBetweenFeature(ConnBetweenFeature connBetweenFeature);

    /**
     * method for receiving all ConnBetweenFeature
     *
     * @return all ConnBetweenFeatures
     */
    List<ConnBetweenFeature> getConnBetweenFeatures();

    /**
     * method for receive specify ConnBetweenFeature by id
     *
     * @param id = uniq ConnBetweenFeature id
     * @return specify ConnBetweenFeature by id
     */
    ConnBetweenFeature getConnBetweenFeatureById(long id);

    /**
     * method for ConnBetweenFeature delete
     *
     * @param id = ConnBetweenFeature's id for delete
     * @return removed ConnBetweenFeature
     */
    ConnBetweenFeature deleteConnBetweenFeature(long id);

    /**
     * method for update ConnBetweenFeature
     *
     * @param connBetweenFeature = update existing ConnBetweenFeature in DB
     * @return updated ConnBetweenFeature
     */
    ConnBetweenFeature updConnBetweenFeature(ConnBetweenFeature connBetweenFeature);

    /**
     * method for receiving all ConnBetweenFeature by connId1 or connId2
     *
     * @return all ConnBetweenFeatures by connId1 or connId2
     */
    List<ConnBetweenFeature> getConnBetweenById(long id);

    /**
     * method for getting all ConnBetweenFeature with description = descr
     *
     * @param descr = field description in table  ConnBetweenFeature
     * @return list all getting rows
     */
    List<ConnBetweenFeature> getByDescription(String descr);
}
