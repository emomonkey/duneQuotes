# Dune Quotes API 🐭🌖

A simple REST API built with Sinatra that serves quotes from the Dune series. Data is stored in MongoDB.

## Features

- RESTful API for retrieving Dune quotes
- Filter quotes by character or quote text
- MongoDB integration with Mongoid
- Ready for deployment on Render

## Prerequisites

- Ruby 3.x
- MongoDB Atlas account (for cloud database)
- Git

## Setup

### 1. Install Dependencies

```bash
bundle install
```

### 2. Configure MongoDB

Create a `mongoid.yml` file in the root directory (use `mongoid.yml.example` as a template):

```bash
cp mongoid.yml.example mongoid.yml
```

Then update `mongoid.yml` with your MongoDB connection string:

```yaml
development:
  clients:
    default:
      uri: "mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@YOUR_CLUSTER.mongodb.net/quotes?retryWrites=true&w=majority"
      options:
        auth_mech: :scram
        server_selection_timeout: 5
```

### 3. Load Sample Quotes (Optional)

```bash
ruby Load_Quotes.rb
```

## Running Locally

```bash
ruby server.rb
```

The API will be available at `http://localhost:4567`

## API Endpoints

### Get All Quotes
```
GET /api/v1/quotes
```

### Filter by Character
```
GET /api/v1/quotes?character=Paul
```

### Filter by Quote Text
```
GET /api/v1/quotes?quote=spice
```

### Response Example
```json
[
  {
    "_id": "...",
    "quote": "The spice must flow.",
    "character": "Dune Universe"
  }
]
```

## Project Structure

- `server.rb` - Main Sinatra application
- `mongoid.yml` - MongoDB configuration (not committed)
- `mongoid.yml.example` - Template for MongoDB configuration
- `Load_Quotes.rb` - Script to populate database with quotes
- `Quotes.yaml` - Sample quote data
- `Gemfile` - Ruby dependencies
- `build.sh` - Build script for deployment

## Deployment on Render

### 1. Push to GitHub

```bash
git push -u origin main
```

### 2. Create Render Service

1. Go to [render.com](https://render.com)
2. Create a new Web Service
3. Connect your GitHub repository
4. Set Build Command: `bash build.sh && bundle install`
5. Add Environment Variable:
   - Key: `MONGODB_URI`
   - Value: Your MongoDB connection string

### 3. Deploy

Render will automatically build and deploy your app!

## Security

- `mongoid.yml` is in `.gitignore` - credentials are never committed
- Use `mongoid.yml.example` as a template for local setup
- On Render, database credentials are stored as environment variables

## License

MIT
