package com.wardrobe.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.PostConstruct;
import java.io.File;

@Configuration
public class FileUploadConfig implements WebMvcConfigurer {

    @Value("${file.upload.path:uploads/}")
    private String uploadPath;

    @PostConstruct
    public void init() {
        // Create upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve uploaded files statically
        // Since context-path is /api, this will be accessible at /api/uploads/**
        // Convert to absolute path to ensure proper file serving
        String absolutePath = getAbsoluteUploadPath();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absolutePath);
    }

    private String getAbsoluteUploadPath() {
        File uploadDir = new File(uploadPath);
        String absolutePath = uploadDir.getAbsolutePath();
        // Ensure path ends with separator for proper resource location
        if (!absolutePath.endsWith(File.separator)) {
            absolutePath += File.separator;
        }
        return absolutePath;
    }

    public String getUploadPath() {
        return uploadPath;
    }
}
