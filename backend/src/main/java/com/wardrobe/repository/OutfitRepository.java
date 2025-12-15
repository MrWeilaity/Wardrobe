package com.wardrobe.repository;

import com.wardrobe.model.Outfit;
import com.wardrobe.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OutfitRepository extends JpaRepository<Outfit, Long> {
    List<Outfit> findByUser(User user);
    List<Outfit> findByUserAndOccasion(User user, String occasion);
}
