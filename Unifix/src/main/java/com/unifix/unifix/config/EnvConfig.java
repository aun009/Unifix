package com.unifix.unifix.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EnvConfig {

    @Bean
    public Dotenv dotenv() {
        try {
            return Dotenv.configure()
                    .directory("./")
                    .filename(".env")
                    .ignoreIfMissing()
                    .load();
        } catch (Exception e) {
            // If .env file doesn't exist, return null
            // Spring will use environment variables instead
            return null;
        }
    }
}
