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
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setAction(action);
        log.setDescription(description);
        activityLogRepository.save(log);
    }
}
