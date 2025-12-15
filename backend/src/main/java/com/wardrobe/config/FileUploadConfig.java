package com.wardrobe.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.PostConstruct;
import java.io.File;
import java.nio.file.Paths;

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
        // Log the actual directory for debugging
        System.out.println("Upload directory created at: " + uploadDir.getAbsolutePath());
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve uploaded files statically
        // Since context-path is /api, this will be accessible at /api/uploads/**
        
        // 使用相对路径的正确方式：
        // Spring Boot 支持相对路径，但需要使用 file:./path/ 格式
        // "./" 表示当前工作目录（即jar文件所在目录或项目根目录）
        
        String resourceLocation;
        if (uploadPath.startsWith("/") || uploadPath.matches("^[A-Za-z]:.*")) {
            // 绝对路径（Linux: /xxx 或 Windows: C:\xxx）
            resourceLocation = "file:" + uploadPath;
        } else {
            // 相对路径：使用 file:./ 前缀，明确表示相对于当前工作目录
            // 移除路径开头的 ./ 如果存在
            String cleanPath = uploadPath.startsWith("./") ? uploadPath.substring(2) : uploadPath;
            resourceLocation = "file:./" + cleanPath;
        }
        
        // 确保路径以 / 结尾
        if (!resourceLocation.endsWith("/")) {
            resourceLocation += "/";
        }
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(resourceLocation);
        
        // 打印实际使用的路径，方便调试
        System.out.println("====================================");
        System.out.println("Static file serving configured:");
        System.out.println("  Handler pattern: /uploads/**");
        System.out.println("  Resource location: " + resourceLocation);
        System.out.println("  Resolved to: " + Paths.get(uploadPath).toAbsolutePath());
        System.out.println("====================================");
    }

    public String getUploadPath() {
        return uploadPath;
    }
}
