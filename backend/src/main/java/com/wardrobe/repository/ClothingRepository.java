package com.wardrobe.repository;

import com.wardrobe.model.Clothing;
import com.wardrobe.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClothingRepository extends JpaRepository<Clothing, Long> {
    List<Clothing> findByUser(User user);
    List<Clothing> findByUserAndCategory(User user, String category);
    List<Clothing> findByUserAndStatus(User user, String status);
    List<Clothing> findByUserAndSeason(User user, String season);
    
    // Admin methods
    List<Clothing> findByUserId(Long userId);
    Long countByUserId(Long userId);
    void deleteByUserId(Long userId);
}
