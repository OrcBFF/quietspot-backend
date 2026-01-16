# QuietSpot Cloud Deployment Guide for Teachers

This guide explains how to deploy the QuietSpot backend and database to the cloud for free, so teachers can evaluate the project without running local servers.

## Prerequisites

- [GitHub Account](https://github.com/) (Required for Render)
- Source code available locally

---

## Part 1: Database Setup (TiDB Cloud - Free MySQL)

We will use **TiDB Cloud** because it offers a generous free tier for MySQL-compatible databases.

1.  **Sign Up**: Go to [TiDB Cloud](https://tidbcloud.com/) and sign up (you can use your Google/GitHub account).
2.  **Create Cluster**:
    - Click **"Create Cluster"**.
    - Select **"Serverless"** (Free Forever).
    - Region: Choose something close (e.g., AWS eu-central-1).
    - Give it a name (e.g., `quietspot-db`).
    - Click **"Create"**.
3.  **Get Credentials**:
    - Once created, you will see a "Connect" dialog.
    - Click **"Generate Password"** if prompted.
    - Copy the connection settings:
        - **Host** (e.g., `gateway01.eu-central-1.prod.aws.tidbcloud.com`)
        - **Port** (usually `4000`)
        - **User** (e.g., `2.root`)
        - **Password** (Save this! You won't see it again)
4.  **Seed the Database**:
    - You need to run your SQL files on this cloud database.
    - Open your terminal in the project root.
    - Run the following command (replace with YOUR values from step 3):
      ```bash
      # Connect to the cloud database
      mysql -h <Host> -P <Port> -u <User> -p
      ```
    - Enter your password.
    - Once connected (you see the `mysql>` prompt), copy-paste the contents of `Raf/quietspot.sql` and press Enter.
    - Then copy-paste the contents of `Raf/seed_quietspot.sql` and press Enter.
    - Type `exit` to close the connection.

---

## Part 2: Backend Setup (Render - Free Node.js Hosting)

We will use **Render** to host the Node.js API.

1.  **Prepare your Repository**:
    - Ensure your code is pushed to a GitHub repository (it can be private).
2.  **Sign Up**: Go to [Render](https://render.com/) and sign up with GitHub.
3.  **Create Web Service**:
    - Click **"New +"** -> **"Web Service"**.
    - Select "Build and deploy from a Git repository".
    - Connect your GitHub account and select your `projectHCI` repo.
4.  **Configure Service**:
    - **Name**: `quietspot-api`
    - **Region**: Same as your database (e.g., Frankfurt).
    - **Root Directory**: `Φάση 3 - QuietSpot/backend` (This is CRITICAL)
    - **Runtime**: Node
    - **Build Command**: `npm install`
    - **Start Command**: `node server.js`
    - **Instance Type**: Free
5.  **Environment Variables**:
    - Scroll down to "Environment Variables" and add these keys/values (using your TiDB credentials):
        - `DB_HOST`: Your TiDB Host
        - `DB_PORT`: `4000`
        - `DB_USER`: Your TiDB User
        - `DB_PASSWORD`: Your TiDB Password
        - `DB_NAME`: `quietspot` (or whatever you named the DB in the SQL file, usually `quietspot`)
        - `DB_SSL`: `true` (This is CRITICAL for cloud DBs)
6.  **Deploy**:
    - Click **"Create Web Service"**.
    - Validating: Wait for the logs to say "Your service is live".
    - Copy your new URL (e.g., `https://quietspot-api.onrender.com`).

---

## Part 3: Build the App for Teachers

Now you need to build the APK that points to this new live server.

1.  **Update API URL**:
    - In your Flutter project, open `lib/services/api_service.dart` (or wherever you defined the URL).
    - Change the `baseUrl` to your new Render URL:
      ```dart
      static const String baseUrl = 'https://quietspot-api.onrender.com';
      ```
2.  **Build APK**:
    - Run:
      ```bash
      flutter build apk --release
      ```
3.  **Locate APK**:
    - The file is at `build/app/outputs/flutter-apk/app-release.apk`.
4.  **Upload**:
    - Upload this `.apk` file to Google Drive, Dropbox, or Helios as instructed.
    - Share the link in your README.

---

## Summary for the README (for Teachers)

In your final submission `README.md`, add a section like this:

### Online Evaluation (No Setup Required)
To evaluate the project without local setup, please download the APK from the link below. The app is pre-configured to connect to a live cloud backend.

- **APK Download**: [Link to your APK]
- **Test User**: (If you have one, provide email/password)

---
