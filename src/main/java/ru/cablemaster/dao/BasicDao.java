package ru.cablemaster.dao;

import org.hibernate.Session;

import java.util.List;

public interface BasicDao<T> {
    /**
     * receiving session
     */
    Session getSessionFactory();

    /**
     * method for add entity
     *
     * @param entity = new entity for creation in DB
     * @return created entity
     */
    T create(T entity);

    /**
     * method for receiving all entity
     *
     * @return all entity
     */
    List<T> getList();

    /**
     * method for receive specify entity by id
     *
     * @param id = uniq entity id
     * @return specify entity by id
     */
    T getById(long id);

    /**
     * method for entity delete
     *
     * @param entity = entity for delete
     * @return removed entity
     */
    T delete(T entity);

    /**
     * method for update entity
     *
     * @param entity = update entity in DB
     * @return updated entity
     */
    T update(T entity);
}


