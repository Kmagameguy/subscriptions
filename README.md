# Subscription Tracker

This is a simple rails application for managing and tracking your personal subscriptions.  It's a really simple/lightweight application that probably doesn't offer much over a simple spreadsheet but it was a nice sandbox for me to experiment with Rails 7 & Hotwired.

## Local Development
This app comes with a basic devcontainer configuration.  If you are using VSCode:
1. See this guide which explains how to configure VSCode for devcontainer development: [Visual Studio Code - Dev Containers Tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial)
1. Clone this repo: `git clone git@github.com:Kmagameguy/subscriptions.git`
1. Open the repo with VSCode: `code subscriptions`
1. VSCode should detect the devcontainer configuration and automatically prompt you to re-open the repo in a devcontainer.  Choose YES and VSCode will build the container for you.
1. Once the container is running you should be able to access it at: `http://localhost:3000`

## Self-Hosting with Docker Compose
If you just want to run the application there are sample `.env` and `docker-compose.yaml` files available:

### Step 1: Install Docker
Complete the following steps:
1. Install Docker Engine by following the [official guide](https://code.visualstudio.com/docs/devcontainers/tutorial)
1. Start the Docker service on your machine
1. Verify that Docker is installed correctly and is running this command:

```
docker run hello-world
# This will succeed if Docker is installed and configured correctly
```

### Step 2: Configure your Environment
Configuration is done through a `.env` file:
1. You can create it by making a copy of the provided `.env.example` file and renaming it to `.env`
1. Open your new `.env` file and update each of the variables according to their instructions
1. Save the file when you're done

### Step 3: Run the Application
1. `cd` into your repo's root directory: `cd /path/to/subscription/repo`
1. Run: `docker compose up`
1. Wait until You see the Rails app come online.  You'll see terminal entries like this: `booting Puma` and `* Listening on http://0.0.0.0:3000`
1. Try to open the application URL in your browser: `http://localhost:3000`

If everything is working correctly, you will see the app home page.

Note: You can also run the app in the background: `docker compose up -d`
