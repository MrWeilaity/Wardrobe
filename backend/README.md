# Smart Wardrobe Backend

Spring Boot backend service for the Smart Wardrobe Management System.

## Tech Stack

- Java 11
- Spring Boot 2.7.18
- Spring Security + JWT
- Spring Data JPA
- H2 Database (development)
- MySQL (production)
- Maven

## Getting Started

### Prerequisites

- Java 11 or higher
- Maven 3.6+

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

### H2 Console

Access H2 console at: `http://localhost:8080/api/h2-console`

- JDBC URL: `jdbc:h2:mem:wardrobedb`
- Username: `sa`
- Password: (leave empty)

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
