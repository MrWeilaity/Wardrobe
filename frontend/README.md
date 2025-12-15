# Smart Wardrobe Frontend

Vue.js 3 frontend application for the Smart Wardrobe Management System with a feminine, elegant design.

## Tech Stack

- Vue.js 3
- Vue Router 4
- Axios
- Vite

## Design Theme

The application features a **feminine color palette** with:
- **Primary Colors**: Soft rose pink (#E8A0A0), dusty pink (#F5C7C7), muted rose (#C9A0A0)
- **Background**: Very soft pink-white (#FFF5F5)
- **Text**: Warm browns for readability
- **Accents**: Soft sage green, peach tones

The design is **warm, elegant, and approachable** - perfect for a personal wardrobe management app.

## Getting Started

### Prerequisites

- Node.js 16+ and npm

### Installation

```bash
cd frontend
npm install
```

### Development

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### Build for Production

```bash
npm run build
```

## Features

### 1. Authentication
- User registration and login
- JWT token-based authentication
- Automatic token refresh

### 2. My Wardrobe (我的衣橱)
- Add, edit, and delete clothing items
- Filter by category (上衣, 裤装, 裙装, 外套, 鞋履, 配饰)
- Filter by season (春, 夏, 秋, 冬, 四季)
- Manage clothing attributes: name, category, color, season, brand, price

### 3. Outfit Plans (穿搭方案)
- Create outfit combinations
- Categorize by occasion (日常, 工作, 约会, 运动, 正式, 休闲)
- Add notes for each outfit
- Track clothing items in each outfit

### 4. Travel Plans (旅行计划)
- Create travel packing lists
- Set destination and dates
- Select travel type (度假休闲, 商务出差, 探险运动)
- Add clothing items to packing list
- View travel history

## API Integration

The frontend connects to the backend API at `http://localhost:8080/api`

All authenticated requests include the JWT token in the Authorization header.

## Color Palette

```css
--primary-color: #E8A0A0;    /* Soft rose pink */
--primary-light: #F5C7C7;    /* Light dusty pink */
--primary-dark: #D67B7B;     /* Deeper rose */
--secondary-color: #D4A5A5;  /* Mauve rose */
--accent-color: #C9A0A0;     /* Muted rose */
--background: #FFF5F5;       /* Very soft pink-white */
--text-primary: #5A3A3A;     /* Warm brown */
--text-secondary: #8B6B6B;   /* Lighter warm brown */
```
