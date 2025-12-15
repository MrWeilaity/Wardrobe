package com.wardrobe.controller;

import com.wardrobe.dto.TravelPlanRequest;
import com.wardrobe.model.Clothing;
import com.wardrobe.model.TravelPlan;
import com.wardrobe.model.User;
import com.wardrobe.repository.ClothingRepository;
import com.wardrobe.repository.TravelPlanRepository;
import com.wardrobe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/travel-plans")
public class TravelPlanController {

    @Autowired
    private TravelPlanRepository travelPlanRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ClothingRepository clothingRepository;

    @GetMapping
    public ResponseEntity<List<TravelPlan>> getAllUserTravelPlans(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        List<TravelPlan> travelPlans = travelPlanRepository.findByUserOrderByStartDateDesc(user);
        return ResponseEntity.ok(travelPlans);
    }

    @GetMapping("/{id}")
    public ResponseEntity<TravelPlan> getTravelPlanById(@PathVariable Long id, 
                                                        Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        TravelPlan travelPlan = travelPlanRepository.findById(id).orElseThrow();
        
        if (!travelPlan.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }
        
        return ResponseEntity.ok(travelPlan);
    }

    @PostMapping
    public ResponseEntity<TravelPlan> createTravelPlan(@Valid @RequestBody TravelPlanRequest request, 
                                                       Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        
        TravelPlan travelPlan = new TravelPlan();
        travelPlan.setUser(user);
        travelPlan.setName(request.getName());
        travelPlan.setDestination(request.getDestination());
        travelPlan.setStartDate(request.getStartDate());
        travelPlan.setEndDate(request.getEndDate());
        travelPlan.setTravelType(request.getTravelType());
        travelPlan.setNotes(request.getNotes());
        
        // Fetch clothing items by IDs
        List<Clothing> clothingItems = new ArrayList<>();
        if (request.getClothingItemIds() != null && !request.getClothingItemIds().isEmpty()) {
            for (Long clothingId : request.getClothingItemIds()) {
                Clothing clothing = clothingRepository.findById(clothingId).orElse(null);
                if (clothing != null && clothing.getUser().getId().equals(user.getId())) {
                    clothingItems.add(clothing);
                }
            }
        }
        travelPlan.setClothingItems(clothingItems);
        
        TravelPlan savedTravelPlan = travelPlanRepository.save(travelPlan);
        return ResponseEntity.ok(savedTravelPlan);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TravelPlan> updateTravelPlan(@PathVariable Long id, 
                                                       @Valid @RequestBody TravelPlanRequest request,
                                                       Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        TravelPlan travelPlan = travelPlanRepository.findById(id).orElseThrow();
        
        if (!travelPlan.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        travelPlan.setName(request.getName());
        travelPlan.setDestination(request.getDestination());
        travelPlan.setStartDate(request.getStartDate());
        travelPlan.setEndDate(request.getEndDate());
        travelPlan.setTravelType(request.getTravelType());
        travelPlan.setNotes(request.getNotes());
        
        // Fetch clothing items by IDs
        List<Clothing> clothingItems = new ArrayList<>();
        if (request.getClothingItemIds() != null && !request.getClothingItemIds().isEmpty()) {
            for (Long clothingId : request.getClothingItemIds()) {
                Clothing clothing = clothingRepository.findById(clothingId).orElse(null);
                if (clothing != null && clothing.getUser().getId().equals(user.getId())) {
                    clothingItems.add(clothing);
                }
            }
        }
        travelPlan.setClothingItems(clothingItems);

        TravelPlan updatedTravelPlan = travelPlanRepository.save(travelPlan);
        return ResponseEntity.ok(updatedTravelPlan);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTravelPlan(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        TravelPlan travelPlan = travelPlanRepository.findById(id).orElseThrow();
        
        if (!travelPlan.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        travelPlanRepository.delete(travelPlan);
        return ResponseEntity.ok().build();
    }
}
