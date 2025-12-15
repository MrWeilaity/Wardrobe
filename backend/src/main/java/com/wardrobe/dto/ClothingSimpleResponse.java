package com.wardrobe.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothingSimpleResponse {
    private Long id;
    private String name;
    private String category;
    private String color;
    private String imageUrl;
}
