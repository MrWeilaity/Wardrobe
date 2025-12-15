package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TravelPlanRequest {
    @NotBlank(message = "Name is required")
    private String name;
    
    private String destination;
    private LocalDate startDate;
    private LocalDate endDate;
    private String travelType;
    private String notes;
    private List<Long> clothingItemIds = new ArrayList<>();
}
