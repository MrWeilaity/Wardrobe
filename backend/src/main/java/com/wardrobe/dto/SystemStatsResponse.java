package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemStatsResponse {
    private long totalUsers;
    private long totalClothing;
    private long totalOutfits;
    private long totalTravelPlans;
    private Map<String, Long> clothingByCategory;
    private Map<String, Long> clothingByColor;
    private Map<String, Long> clothingBySeason;
}
