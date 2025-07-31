# emote-generator

Build emotes with ease.

An emote generation system that allows users to create custom emotes by combining different facial features (head, eyes, eyebrows, mouth) for various characters.

## 🏗️ Architecture

- **Backend API**: Node.js/Express/TypeScript server on port 4000
- **Frontend**: Vue.js 3/Quasar application on port 5173
- **Live Reload**: Both services automatically reload on file changes

## 🚀 Development

### Prerequisites

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Node.js 24.4.1** (for local development without Docker)
- **Git**

### Quick Start (Recommended)

Run a single command to start both the backend API and frontend with live reload:

```bash
./dev.sh
```

This will:
- ✅ Start the backend API on http://localhost:4000
- ✅ Start the frontend on http://localhost:5173
- ✅ Enable live reload for both services
- ✅ Mount your local files for instant updates

### Manual Development Setup

If you prefer to run services individually:

```bash
# Start both services with Docker Compose
docker compose up --build

# Or start services in the background
docker compose up -d --build

# Stop services
docker compose down
```

### Local Development (Without Docker)

If you prefer to run services locally without Docker:

#### Backend Setup
```bash
# Install dependencies
npm install

# Start development server with live reload
npm run dev:server

# Or just compile TypeScript in watch mode
npm run dev
```

#### Frontend Setup
```bash
# Navigate to generator directory
cd generator

# Install dependencies
npm install

# Start development server
npm run dev
```

## 📁 Project Structure

```
emote-generator/
├── src/                    # Backend API source code
│   ├── app.ts             # Express server setup
│   ├── routes.ts          # API endpoints
│   ├── emote.ts           # Emote generation logic
│   ├── blueprint.ts       # Blueprint management
│   ├── part.ts            # Part management
│   └── types/             # TypeScript type definitions
├── generator/              # Frontend Vue.js application
│   ├── src/
│   │   ├── components/    # Vue components
│   │   ├── stores/        # Pinia state management
│   │   └── App.vue        # Main application component
│   └── package.json
├── assets/                 # Static assets
│   ├── emotes/            # Character part images
│   └── blueprints/        # Character blueprint definitions
├── docker-compose.yml     # Development environment
├── Dockerfile.dev         # Backend development container
└── dev.sh                 # Development startup script
```

## 🔧 Available Commands

### Backend (Root Directory)
```bash
npm run build          # Compile TypeScript
npm run dev            # Compile TypeScript in watch mode
npm run dev:server     # Start server with live reload
npm run start          # Start production server
npm run lint           # Run ESLint
```

### Frontend (generator/ Directory)
```bash
npm run dev            # Start Vite development server
npm run build          # Build for production
npm run lint           # Run ESLint
```

### Docker Commands
```bash
./dev.sh               # Start development environment
docker compose up      # Start services
docker compose down    # Stop services
docker compose logs    # View logs
docker compose ps      # Check service status
```

## 🌐 API Endpoints

### Emote Generation
- `GET /emote` - Generate emotes (by blueprint key or custom parts)
- `GET /emote/cache` - List cached emotes

### Parts Management
- `GET /part` - List all available parts
- `GET /part/:character` - List parts for specific character

### Blueprint Management
- `GET /blueprint` - List all blueprints
- `GET /blueprint/:character` - List blueprints for specific character

## 🎨 Character System

### Adding New Characters

1. **Add Character Parts** to `assets/emotes/`:
   ```
   {character}_{part}_{expression}.png
   Example: sophie_eyes_happy.png
   ```

2. **Create Blueprint File** in `assets/blueprints/`:
   ```json
   {
     "sophie_happy": {
       "character": "sophie",
       "head": "normal",
       "eyes": "happy",
       "eyebrows": "normal",
       "mouth": "smile"
     }
   }
   ```

### Supported Parts
- **head**: Different head poses/expressions
- **eyes**: Various eye expressions (normal, happy, angry, shocked, etc.)
- **eyebrows**: Different eyebrow positions (normal, angry, surprised, etc.)
- **mouth**: Various mouth expressions (smile, pout, yell, grin, etc.)

## 🔄 Live Reload Features

- **Backend**: Changes to `src/` files automatically recompile and restart the server
- **Frontend**: Changes to `generator/src/` files automatically reload in the browser
- **Assets**: Changes to `assets/` are immediately available

## 🛠️ Troubleshooting

### Common Issues

#### Docker Issues
```bash
# Clean rebuild if you encounter build issues
docker compose down --volumes
docker compose up --build

# Check service logs
docker compose logs api
docker compose logs frontend

# Check service status
docker compose ps
```

#### Port Conflicts
If ports 4000 or 5173 are already in use:
```bash
# Find processes using the ports
lsof -i :4000
lsof -i :5173

# Kill the processes or change ports in docker-compose.yml
```

### Development Tips

1. **File Watching**: The development environment uses file watching for live reload. If you're on macOS or Linux, you might need to increase the file watch limit:
   ```bash
   echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
   sudo sysctl -p
   ```

2. **Environment Variables**: Create a `.env` file in the root directory for local development:
   ```
   NODE_ENV=development
   PORT=4000
   VITE_DEVELOPMENT_API_URL=http://localhost:4000
   ```
