package ru.cablemaster.config.application;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import ru.cablemaster.dao.FeatureCoordDao;
import ru.cablemaster.dao.FeatureLonLatDao;
import ru.cablemaster.dao.FeatureNextIdDao;
import ru.cablemaster.dao.impl.FeatureCoordDaoImpl;
import ru.cablemaster.dao.impl.FeatureLonLatDaoImpl;
import ru.cablemaster.dao.impl.FeatureNextIdDaoImpl;
import ru.cablemaster.entity.FeatureCoord;
import ru.cablemaster.entity.FeatureLonLat;
import ru.cablemaster.entity.FeatureNextId;

@Configuration
@PropertySource(value = "classpath:util.properties")
@PropertySource(value = "classpath:auth.properties")
public class AppConfig {
    @Autowired
    private Environment environment;

    @Bean
    public DriverManagerDataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(environment.getRequiredProperty("jdbc.mariadb.driver"));
        dataSource.setUrl(environment.getRequiredProperty("jdbc.mariadb.url"));
        dataSource.setUsername(environment.getRequiredProperty("jdbc.mariadb.user"));
        dataSource.setPassword(environment.getRequiredProperty("jdbc.mariadb.password"));
        return dataSource;
    }

    @Bean
    public FeatureLonLatDao featureLonLatDao(){
        return new FeatureLonLatDaoImpl(FeatureLonLat.class);
    }

    @Bean
    public FeatureCoordDao featureCoordDao(){
        return new FeatureCoordDaoImpl(FeatureCoord.class);
    }

    @Bean
    public FeatureNextIdDao featureNextIdDao(){
        return new FeatureNextIdDaoImpl(FeatureNextId.class);
    }
}
