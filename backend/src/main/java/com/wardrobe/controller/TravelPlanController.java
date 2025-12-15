package com.wardrobe.controller;

import com.wardrobe.model.TravelPlan;
import com.wardrobe.model.User;
import com.wardrobe.repository.TravelPlanRepository;
import com.wardrobe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/travel-plans")
public class TravelPlanController {

    @Autowired
    private TravelPlanRepository travelPlanRepository;

    @Autowired
    private UserRepository userRepository;

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
    public ResponseEntity<TravelPlan> createTravelPlan(@Valid @RequestBody TravelPlan travelPlan, 
                                                       Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        travelPlan.setUser(user);
        TravelPlan savedTravelPlan = travelPlanRepository.save(travelPlan);
        return ResponseEntity.ok(savedTravelPlan);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TravelPlan> updateTravelPlan(@PathVariable Long id, 
                                                       @Valid @RequestBody TravelPlan travelPlanDetails,
                                                       Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        TravelPlan travelPlan = travelPlanRepository.findById(id).orElseThrow();
        
        if (!travelPlan.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        travelPlan.setName(travelPlanDetails.getName());
        travelPlan.setDestination(travelPlanDetails.getDestination());
        travelPlan.setStartDate(travelPlanDetails.getStartDate());
        travelPlan.setEndDate(travelPlanDetails.getEndDate());
        travelPlan.setTravelType(travelPlanDetails.getTravelType());
        travelPlan.setClothingItems(travelPlanDetails.getClothingItems());
        travelPlan.setNotes(travelPlanDetails.getNotes());

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
