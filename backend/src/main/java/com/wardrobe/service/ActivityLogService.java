package com.wardrobe.service;

import com.wardrobe.model.ActivityLog;
import com.wardrobe.repository.ActivityLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActivityLogService {

    @Autowired
    private ActivityLogRepository activityLogRepository;

    public void log(Long userId, String username, String action, String description) {
        // Validate input parameters
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        if (action == null || action.trim().isEmpty()) {
            throw new IllegalArgumentException("Action cannot be null or empty");
        }
        if (description == null) {
            description = "";
        }
        
        // Enforce length limits
        if (username.length() > 50) {
            username = username.substring(0, 50);
        }
        if (action.length() > 100) {
            action = action.substring(0, 100);
        }
        if (description.length() > 255) {
            description = description.substring(0, 255);
        }
        
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setAction(action);
        log.setDescription(description);
        activityLogRepository.save(log);
    }
}
