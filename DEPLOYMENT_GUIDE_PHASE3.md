# Deployment Guide for QuietSpot (Phase 3)

This guide will help you deploy your backend and database to free cloud services so your project is accessible to teachers without running locally.

## Prerequisities
- A **GitHub** account.
- A **Render** account (for backend hosting). https://render.com/
- A **TiDB Cloud** account (for free MySQL database). https://tidbcloud.com/
  - *Alternative*: **Aiven for MySQL**.

---

## Part 1: Database Setup (TiDB Cloud)

1.  **Create a Cluster**:
    -   Log in to TiDB Cloud.
    -   Create a new "Serverless" cluster (Free).
    -   Give it a name (e.g., `quietspot-db`).
2.  **Get Connection Details**:
    -   Once created, click "Connect".
    -   Note down the following:
        -   **Host** (e.g., `gateway01.us-west-2.prod.aws.tidbcloud.com`)
        -   **Port** (e.g., `4000`)
        -   **User** (e.g., `2.root`)
        -   **Password** (Generate one if needed)
3.  **Initialize the Database**:
    -   You need to run the SQL files from your project on this new remote database.
    -   **Option A (Command Line)**:
        If you have `mysql` installed locally, run:
        ```bash
        mysql -h <HOST> -P <PORT> -u <USER> -p<PASSWORD> --ssl-ca=/etc/ssl/certs/ca-certificates.crt < Raf/quietspot.sql
        mysql -h <HOST> -P <PORT> -u <USER> -p<PASSWORD> --ssl-ca=/etc/ssl/certs/ca-certificates.crt < Raf/seed_quietspot.sql
        ```
    -   **Option B (Web CLI)**:
        -   Use the "SQL Editor" in the TiDB dashboard.
        -   Copy content from `Raf/quietspot.sql` and paste it into the editor. Run it.
        -   Copy content from `Raf/seed_quietspot.sql` and paste it into the editor. Run it.

---

## Part 2: Backend Deployment (Render)

1.  **Push Code to GitHub**:
    -   Create a new repository on GitHub (e.g., `quietspot-backend`).
    -   Run these commands in your project terminal:
        ```bash
        git add .
        git commit -m "Initial commit for deployment"
        git branch -M main
        git remote add origin https://github.com/<YOUR_USERNAME>/quietspot-backend.git
        git push -u origin main
        ```
2.  **Create Service on Render**:
    -   Click "New +" -> "Web Service".
    -   Connect your GitHub repository.
    -   **Settings**:
        -   **Name**: `quietspot-api`
        -   **Region**: Closest to you (e.g., Frankfurt/London).
        -   **Branch**: `main`
        -   **Root Directory**: `backend` (Important! Your package.json is inside backend/)
        -   **Runtime**: Node
        -   **Build Command**: `npm install`
        -   **Start Command**: `node server.js`
3.  **Environment Variables**:
    -   Scroll down to "Environment Variables" and add these keys (using values from TiDB):
        -   `DB_HOST`: (from TiDB)
        -   `DB_PORT`: (from TiDB, usually 4000)
        -   `DB_USER`: (from TiDB)
        -   `DB_PASSWORD`: (from TiDB)
        -   `DB_NAME`: `quietspot` (or `test` if TiDB default)
        -   `DB_SSL`: `true`
4.  **Deploy**:
    -   Click "Create Web Service".
    -   Wait for the build to finish. You should see "✅ Connected to MySQL database" in the logs.
    -   **Copy your backend URL** (e.g., `https://quietspot-api.onrender.com`).

---

## Part 3: Create Release APK

Once the backend is live, we will build the App connected to it.

1.  **Run the Build Command**:
    Replace `YOUR_RENDER_URL` with the URL you copied above.
    ```bash
    flutter build apk --release --dart-define=API_BASE_URL=https://quietspot-api.onrender.com
    ```
2.  **Locate the APK**:
    -   The file will be at `build/app/outputs/flutter-apk/app-release.apk`.
    -   Send this file to your teachers/evaluators.
