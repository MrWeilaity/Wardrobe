package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothingResponse {
    private Long id;
    private Long userId;
    private String name;
    private String category;
    private String color;
    private String size;
    private String brand;
    private Double price;
    private String material;
    private String season;
    private String imageUrl;
    private LocalDate purchaseDate;
    private Integer wearCount;
    private String status;
    private Set<String> tags;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
