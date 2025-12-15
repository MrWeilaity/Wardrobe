package com.wardrobe.controller;

import com.wardrobe.dto.SystemStatsResponse;
import com.wardrobe.dto.UserResponse;
import com.wardrobe.model.Clothing;
import com.wardrobe.model.User;
import com.wardrobe.repository.ClothingRepository;
import com.wardrobe.repository.OutfitRepository;
import com.wardrobe.repository.TravelPlanRepository;
import com.wardrobe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ClothingRepository clothingRepository;

    @Autowired
    private OutfitRepository outfitRepository;

    @Autowired
    private TravelPlanRepository travelPlanRepository;

    @Autowired
    private com.wardrobe.repository.ActivityLogRepository activityLogRepository;

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        List<User> users = userRepository.findAll();
        List<UserResponse> userResponses = users.stream().map(user -> {
            UserResponse response = new UserResponse();
            response.setId(user.getId());
            response.setUsername(user.getUsername());
            response.setEmail(user.getEmail());
            response.setRoles(user.getRoles());
            response.setCreatedAt(user.getCreatedAt());
            
            // Count user's items
            response.setClothingCount(clothingRepository.countByUserId(user.getId()));
            response.setOutfitCount(outfitRepository.countByUserId(user.getId()));
            response.setTravelPlanCount(travelPlanRepository.countByUserId(user.getId()));
            
            return response;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(userResponses);
    }

    @GetMapping("/stats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SystemStatsResponse> getSystemStats() {
        SystemStatsResponse stats = new SystemStatsResponse();
        
        // Basic counts
        stats.setTotalUsers(userRepository.count());
        stats.setTotalClothing(clothingRepository.count());
        stats.setTotalOutfits(outfitRepository.count());
        stats.setTotalTravelPlans(travelPlanRepository.count());

        // Clothing by category
        List<Clothing> allClothing = clothingRepository.findAll();
        Map<String, Long> byCategory = allClothing.stream()
                .collect(Collectors.groupingBy(
                        c -> c.getCategory() != null ? c.getCategory() : "未分类",
                        Collectors.counting()
                ));
        stats.setClothingByCategory(byCategory);

        // Clothing by color
        Map<String, Long> byColor = allClothing.stream()
                .filter(c -> c.getColor() != null && !c.getColor().isEmpty())
                .collect(Collectors.groupingBy(
                        Clothing::getColor,
                        Collectors.counting()
                ));
        stats.setClothingByColor(byColor);

        // Clothing by season
        Map<String, Long> bySeason = allClothing.stream()
                .filter(c -> c.getSeason() != null && !c.getSeason().isEmpty())
                .collect(Collectors.groupingBy(
                        Clothing::getSeason,
                        Collectors.counting()
                ));
        stats.setClothingBySeason(bySeason);

        return ResponseEntity.ok(stats);
    }

    @DeleteMapping("/users/{userId}")
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        if (!userRepository.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }

        try {
            // Delete user's clothing first (cascade)
            clothingRepository.deleteByUserId(userId);
            
            // Delete user's outfits
            outfitRepository.deleteByUserId(userId);
            
            // Delete user's travel plans
            travelPlanRepository.deleteByUserId(userId);
            
            // Delete user
            userRepository.deleteById(userId);

            Map<String, String> response = new HashMap<>();
            response.put("message", "User deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // Log internally but return generic message
            System.err.println("Error deleting user: " + e.getMessage());
            return ResponseEntity.status(500).body("Failed to delete user");
        }
    }

    @GetMapping("/users/{userId}/details")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getUserDetails(@PathVariable Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        User user = userOpt.get();
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setRoles(user.getRoles());
        response.setCreatedAt(user.getCreatedAt());
        response.setClothingCount(clothingRepository.countByUserId(user.getId()));
        response.setOutfitCount(outfitRepository.countByUserId(user.getId()));
        response.setTravelPlanCount(travelPlanRepository.countByUserId(user.getId()));

        return ResponseEntity.ok(response);
    }

    @PutMapping("/users/{userId}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateUserRole(@PathVariable Long userId, @RequestBody Map<String, String> request) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        User user = userOpt.get();
        String action = request.get("action"); // "add" or "remove"
        String role = request.get("role"); // "ROLE_ADMIN" or "ROLE_USER"

        if (action == null || role == null) {
            return ResponseEntity.badRequest().body("Action and role are required");
        }

        Set<String> roles = user.getRoles();
        if ("add".equals(action)) {
            roles.add(role);
        } else if ("remove".equals(action)) {
            roles.remove(role);
        } else {
            return ResponseEntity.badRequest().body("Invalid action");
        }

        user.setRoles(roles);
        userRepository.save(user);

        Map<String, String> response = new HashMap<>();
        response.put("message", "User role updated successfully");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/clothing")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Clothing>> getAllClothing() {
        List<Clothing> clothing = clothingRepository.findAll();
        return ResponseEntity.ok(clothing);
    }

    @GetMapping("/users/{userId}/clothing")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Clothing>> getUserClothing(@PathVariable Long userId) {
        List<Clothing> clothing = clothingRepository.findByUserId(userId);
        return ResponseEntity.ok(clothing);
    }

    @GetMapping("/activity-logs")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getActivityLogs() {
        try {
            List<com.wardrobe.model.ActivityLog> logs = activityLogRepository.findTop50ByOrderByCreatedAtDesc();
            return ResponseEntity.ok(logs);
        } catch (Exception e) {
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @GetMapping("/stats/growth")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> getGrowthStats() {
        Map<String, Object> growthStats = new HashMap<>();
        
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime last7Days = now.minusDays(7);
        java.time.LocalDateTime last30Days = now.minusDays(30);
        
        // Count new users in last 7 and 30 days using optimized queries
        long newUsersLast7Days = userRepository.countByCreatedAtAfter(last7Days);
        long newUsersLast30Days = userRepository.countByCreatedAtAfter(last30Days);
        
        growthStats.put("newUsersLast7Days", newUsersLast7Days);
        growthStats.put("newUsersLast30Days", newUsersLast30Days);
        
        // Activity counts
        try {
            long activitiesLast7Days = activityLogRepository.countByCreatedAtAfter(last7Days);
            long activitiesLast30Days = activityLogRepository.countByCreatedAtAfter(last30Days);
            growthStats.put("activitiesLast7Days", activitiesLast7Days);
            growthStats.put("activitiesLast30Days", activitiesLast30Days);
        } catch (Exception e) {
            growthStats.put("activitiesLast7Days", 0);
            growthStats.put("activitiesLast30Days", 0);
        }
        
        return ResponseEntity.ok(growthStats);
    }
}
