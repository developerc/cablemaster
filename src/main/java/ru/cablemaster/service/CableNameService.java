package ru.cablemaster.service;

import ru.cablemaster.entity.CableName;

import java.util.List;

public interface CableNameService {
    /**
     * method for add cable name to base
     *
     * @param cableName = new cableName for creation in DB
     * @return created cableName
     */
    CableName addCableName(CableName cableName);

    /**
     * method for receiving all cable names
     *
     * @return all CableNames
     */
    List<CableName> getAllCableNames();

    /**
     * method for receive specify cableName by id
     *
     * @param id = uniq CableName id
     * @return specify CableName by id
     */
    CableName getCableNameById(long id);

    /**
     * method for cableName delete
     *
     * @param id = CableName's id for delete
     * @return removed cableName
     */
    CableName deleteCableName(long id);

    /**
     * method for update cableName
     *
     * @param cableName = update existing cableName in DB
     * @return updated cableName
     */
    CableName updCableName(CableName cableName);
}
