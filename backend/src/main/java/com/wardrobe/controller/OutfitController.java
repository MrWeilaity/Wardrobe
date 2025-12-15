package com.wardrobe.controller;

import com.wardrobe.dto.OutfitRequest;
import com.wardrobe.model.Clothing;
import com.wardrobe.model.Outfit;
import com.wardrobe.model.User;
import com.wardrobe.repository.ClothingRepository;
import com.wardrobe.repository.OutfitRepository;
import com.wardrobe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/outfits")
public class OutfitController {

    @Autowired
    private OutfitRepository outfitRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ClothingRepository clothingRepository;

    @GetMapping
    public ResponseEntity<List<Outfit>> getAllUserOutfits(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        List<Outfit> outfits = outfitRepository.findByUser(user);
        return ResponseEntity.ok(outfits);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Outfit> getOutfitById(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Outfit outfit = outfitRepository.findById(id).orElseThrow();
        
        if (!outfit.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }
        
        return ResponseEntity.ok(outfit);
    }

    @PostMapping
    public ResponseEntity<Outfit> createOutfit(@Valid @RequestBody OutfitRequest request, 
                                               Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        
        Outfit outfit = new Outfit();
        outfit.setUser(user);
        outfit.setName(request.getName());
        outfit.setOccasion(request.getOccasion());
        outfit.setNotes(request.getNotes());
        
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
        outfit.setClothingItems(clothingItems);
        
        Outfit savedOutfit = outfitRepository.save(outfit);
        return ResponseEntity.ok(savedOutfit);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Outfit> updateOutfit(@PathVariable Long id, 
                                               @Valid @RequestBody OutfitRequest request,
                                               Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Outfit outfit = outfitRepository.findById(id).orElseThrow();
        
        if (!outfit.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        outfit.setName(request.getName());
        outfit.setOccasion(request.getOccasion());
        outfit.setNotes(request.getNotes());
        
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
        outfit.setClothingItems(clothingItems);

        Outfit updatedOutfit = outfitRepository.save(outfit);
        return ResponseEntity.ok(updatedOutfit);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteOutfit(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Outfit outfit = outfitRepository.findById(id).orElseThrow();
        
        if (!outfit.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        outfitRepository.delete(outfit);
        return ResponseEntity.ok().build();
    }
}
