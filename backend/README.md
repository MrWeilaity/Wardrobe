# Smart Wardrobe Backend

Spring Boot backend service for the Smart Wardrobe Management System.

## Tech Stack

- Java 11
- Spring Boot 2.7.18
- Spring Security + JWT
- Spring Data JPA
- **MySQL 5.7 Database**
- Maven

## Getting Started

### Prerequisites

- Java 11 or higher
- Maven 3.6+
- **MySQL 5.7**

### Database Setup

1. Install MySQL 5.7
2. Create database:
```sql
CREATE DATABASE wardrobe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Or run the provided schema:
```bash
mysql -u root -p < src/main/resources/schema.sql
```

3. Update database credentials in `src/main/resources/application.yml` if needed:
```yaml
spring:
  datasource:
    username: root
    password: root  # Change this to your MySQL password
```

详细配置说明请查看：`数据库配置说明.md`

### Running the Application

```bash
cd backend
mvn spring-boot:run
```

The server will start on `http://localhost:8080`

### API Endpoints

#### Authentication
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login and get JWT token

#### Clothing Management
- `GET /api/clothing` - Get all user's clothing
- `POST /api/clothing` - Add new clothing item
- `GET /api/clothing/{id}` - Get specific clothing item
- `PUT /api/clothing/{id}` - Update clothing item
- `DELETE /api/clothing/{id}` - Delete clothing item
- `GET /api/clothing/category/{category}` - Get clothing by category

#### Outfit Management
- `GET /api/outfits` - Get all user's outfits
- `POST /api/outfits` - Create new outfit
- `GET /api/outfits/{id}` - Get specific outfit
- `PUT /api/outfits/{id}` - Update outfit
- `DELETE /api/outfits/{id}` - Delete outfit

#### Travel Plans
- `GET /api/travel-plans` - Get all user's travel plans
- `POST /api/travel-plans` - Create new travel plan
- `GET /api/travel-plans/{id}` - Get specific travel plan
- `PUT /api/travel-plans/{id}` - Update travel plan
- `DELETE /api/travel-plans/{id}` - Delete travel plan

### MySQL Connection

The application connects to MySQL with the following default settings:

- Host: `localhost:3306`
- Database: `wardrobe`
- Username: `root`
- Password: `root`
- Driver: MySQL 5.7 JDBC Driver

You can connect to MySQL using:
```bash
mysql -u root -p wardrobe
```

## Project Structure

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/wardrobe/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── controller/      # REST controllers
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── model/           # Entity models
│   │   │   ├── repository/      # JPA repositories
│   │   │   ├── security/        # Security & JWT
│   │   │   └── WardrobeApplication.java
│   │   └── resources/
│   │       └── application.yml
│   └── test/
└── pom.xml
```

## Security

The API uses JWT (JSON Web Token) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Database Schema

### Main Tables
- `users` - User accounts
- `clothing` - Clothing items
- `outfits` - Outfit combinations
- `travel_plans` - Travel packing lists
- `outfit_clothing` - Many-to-many relationship
- `travel_clothing` - Many-to-many relationship
- `clothing_tags` - Clothing tags
- `user_roles` - User roles

## Building for Production

```bash
mvn clean package
java -jar target/smart-wardrobe-backend-1.0.0.jar
```

## Configuration

Edit `src/main/resources/application.yml` to configure:
- Database connection
- JWT secret and expiration
- CORS allowed origins
- Server port
