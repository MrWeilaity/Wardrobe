package com.wardrobe.controller;

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
    public ResponseEntity<Outfit> createOutfit(@Valid @RequestBody Outfit outfit, 
                                               Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        outfit.setUser(user);
        Outfit savedOutfit = outfitRepository.save(outfit);
        return ResponseEntity.ok(savedOutfit);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Outfit> updateOutfit(@PathVariable Long id, 
                                               @Valid @RequestBody Outfit outfitDetails,
                                               Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Outfit outfit = outfitRepository.findById(id).orElseThrow();
        
        if (!outfit.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        outfit.setName(outfitDetails.getName());
        outfit.setOccasion(outfitDetails.getOccasion());
        outfit.setNotes(outfitDetails.getNotes());
        outfit.setClothingItems(outfitDetails.getClothingItems());

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
