package com.wardrobe.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/upload")
@CrossOrigin(origins = "*")
public class FileUploadController {

    @Value("${file.upload.path:uploads/}")
    private String uploadPath;

    @Value("${server.servlet.context-path:/api}")
    private String contextPath;

    @PostMapping("/image")
    public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a file to upload");
        }

        try {
            // Validate file type
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body("Only image files are allowed");
            }

            // Validate file size (max 5MB)
            if (file.getSize() > 5 * 1024 * 1024) {
                return ResponseEntity.badRequest().body("File size must be less than 5MB");
            }

            // Generate unique filename
            String originalFilename = file.getOriginalFilename();
            String fileExtension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + fileExtension;

            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save file
            Path filePath = Paths.get(uploadPath + filename);
            Files.write(filePath, file.getBytes());

            // Return file URL
            // Since the frontend uses baseURL '/api' and Spring serves resources under context-path
            // we return the full path including /api
            String fileUrl = contextPath + "/uploads/" + filename;
            Map<String, String> response = new HashMap<>();
            response.put("url", fileUrl);
            response.put("filename", filename);

            return ResponseEntity.ok(response);

        } catch (IOException e) {
            // Log error internally
            System.err.println("File upload error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body("Failed to upload file. Please try again.");
        }
    }

    @DeleteMapping("/image")
    public ResponseEntity<?> deleteImage(@RequestParam("filename") String filename) {
        try {
            // Validate filename to prevent directory traversal
            if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
                return ResponseEntity.badRequest().body("Invalid filename");
            }

            Path filePath = Paths.get(uploadPath + filename);
            Files.deleteIfExists(filePath);

            Map<String, String> response = new HashMap<>();
            response.put("message", "File deleted successfully");

            return ResponseEntity.ok(response);

        } catch (IOException e) {
            // Log error internally
            System.err.println("File deletion error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body("Failed to delete file. Please try again.");
        }
    }
}
