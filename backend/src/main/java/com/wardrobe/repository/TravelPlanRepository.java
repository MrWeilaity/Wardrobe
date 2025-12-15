package com.wardrobe.repository;

import com.wardrobe.model.TravelPlan;
import com.wardrobe.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TravelPlanRepository extends JpaRepository<TravelPlan, Long> {
    List<TravelPlan> findByUser(User user);
    List<TravelPlan> findByUserOrderByStartDateDesc(User user);
}
