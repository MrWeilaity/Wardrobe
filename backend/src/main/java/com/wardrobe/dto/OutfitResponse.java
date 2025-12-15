package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OutfitResponse {
    private Long id;
    private Long userId;
    private String name;
    private String occasion;
    private String notes;
    private List<ClothingSimpleResponse> clothingItems;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
