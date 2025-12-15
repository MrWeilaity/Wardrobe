package com.wardrobe.controller;

import com.wardrobe.model.Clothing;
import com.wardrobe.model.User;
import com.wardrobe.repository.ClothingRepository;
import com.wardrobe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/clothing")
public class ClothingController {

    @Autowired
    private ClothingRepository clothingRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<Clothing>> getAllUserClothing(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        List<Clothing> clothing = clothingRepository.findByUser(user);
        return ResponseEntity.ok(clothing);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Clothing> getClothingById(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Clothing clothing = clothingRepository.findById(id).orElseThrow();
        
        if (!clothing.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }
        
        return ResponseEntity.ok(clothing);
    }

    @PostMapping
    public ResponseEntity<Clothing> createClothing(@Valid @RequestBody Clothing clothing, 
                                                   Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        clothing.setUser(user);
        Clothing savedClothing = clothingRepository.save(clothing);
        return ResponseEntity.ok(savedClothing);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Clothing> updateClothing(@PathVariable Long id, 
                                                   @Valid @RequestBody Clothing clothingDetails,
                                                   Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Clothing clothing = clothingRepository.findById(id).orElseThrow();
        
        if (!clothing.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        clothing.setName(clothingDetails.getName());
        clothing.setCategory(clothingDetails.getCategory());
        clothing.setColor(clothingDetails.getColor());
        clothing.setSize(clothingDetails.getSize());
        clothing.setBrand(clothingDetails.getBrand());
        clothing.setPrice(clothingDetails.getPrice());
        clothing.setMaterial(clothingDetails.getMaterial());
        clothing.setSeason(clothingDetails.getSeason());
        clothing.setImageUrl(clothingDetails.getImageUrl());
        clothing.setPurchaseDate(clothingDetails.getPurchaseDate());
        clothing.setStatus(clothingDetails.getStatus());
        clothing.setTags(clothingDetails.getTags());

        Clothing updatedClothing = clothingRepository.save(clothing);
        return ResponseEntity.ok(updatedClothing);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteClothing(@PathVariable Long id, Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        Clothing clothing = clothingRepository.findById(id).orElseThrow();
        
        if (!clothing.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        clothingRepository.delete(clothing);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<Clothing>> getClothingByCategory(@PathVariable String category, 
                                                                Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName()).orElseThrow();
        List<Clothing> clothing = clothingRepository.findByUserAndCategory(user, category);
        return ResponseEntity.ok(clothing);
    }
}
