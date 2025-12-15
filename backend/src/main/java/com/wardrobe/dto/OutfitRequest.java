package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutfitRequest {
    @NotBlank(message = "Name is required")
    private String name;
    
    private String occasion;
    private String notes;
    private List<Long> clothingItemIds = new ArrayList<>();
}
