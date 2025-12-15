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
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ClothingRepository clothingRepository;

    @Autowired
    private OutfitRepository outfitRepository;

    @Autowired
    private TravelPlanRepository travelPlanRepository;

    @GetMapping("/users")
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        List<User> users = userRepository.findAll();
        List<UserResponse> userResponses = users.stream().map(user -> {
            UserResponse response = new UserResponse();
            response.setId(user.getId());
            response.setUsername(user.getUsername());
            response.setEmail(user.getEmail());
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
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        if (!userRepository.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }

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
    }

    @GetMapping("/users/{userId}/details")
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
        response.setCreatedAt(user.getCreatedAt());
        response.setClothingCount(clothingRepository.countByUserId(user.getId()));
        response.setOutfitCount(outfitRepository.countByUserId(user.getId()));
        response.setTravelPlanCount(travelPlanRepository.countByUserId(user.getId()));

        return ResponseEntity.ok(response);
    }
}
