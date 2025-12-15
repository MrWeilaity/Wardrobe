package com.wardrobe.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "clothing")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Clothing {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotBlank
    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String category;  // 上衣、裤装、裙装、外套、鞋履、配饰

    private String color;
    private String size;
    private String brand;
    private Double price;
    private String material;
    private String season;  // 春、夏、秋、冬、四季

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "purchase_date")
    private LocalDate purchaseDate;

    @Column(name = "wear_count")
    private Integer wearCount = 0;

    private String status;  // 在用、闲置、待捐赠、已回收

    @ElementCollection
    @CollectionTable(name = "clothing_tags", joinColumns = @JoinColumn(name = "clothing_id"))
    @Column(name = "tag")
    private Set<String> tags = new HashSet<>();

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (wearCount == null) {
            wearCount = 0;
        }
        if (status == null) {
            status = "在用";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
