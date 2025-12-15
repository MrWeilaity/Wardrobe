package com.wardrobe.repository;

import com.wardrobe.model.ActivityLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ActivityLogRepository extends JpaRepository<ActivityLog, Long> {
    List<ActivityLog> findTop50ByOrderByCreatedAtDesc();
    List<ActivityLog> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<ActivityLog> findByCreatedAtAfterOrderByCreatedAtDesc(LocalDateTime date);
    Long countByCreatedAtAfter(LocalDateTime date);
}
