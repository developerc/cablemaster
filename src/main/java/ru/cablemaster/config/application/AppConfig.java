package ru.cablemaster.config.application;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

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
}
