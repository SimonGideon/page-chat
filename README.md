## Page Chat

<img width="1920" height="2460" alt="screencapture-localhost-5173-read-79c3d55a-f51f-472d-b8e9-d3e847a0dee9-2025-12-29-00_02_27" src="https://github.com/user-attachments/assets/bcc37bcd-76ea-4ca8-addb-51793a79bfcf" />
<img width="1920" height="1022" alt="screencapture-localhost-5173-profile-2025-12-29-00_03_55" src="https://github.com/user-attachments/assets/78be5fa7-f61f-4cc1-b106-f397d635c0cd" />

## Local Development Against Remote Database

The app uses the **production PostgreSQL** on the server even in development. Since the database is not publicly exposed, connect via an SSH tunnel.

**1. Open the tunnel** (run once before starting Rails):

```bash
ssh -L 5432:localhost:5432 epic@89.167.4.31 -N -f
```

This forwards your local port `5432` to the server's PostgreSQL in the background.

**2. Start the backend normally:**

```bash
cd back-end
rails s
```

**3. Close the tunnel when done:**

```bash
pkill -f "ssh -L 5432"
```





