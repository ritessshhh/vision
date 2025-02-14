# Homework Assignment

## Problem 1: HTTP and DNS Basics

### Question 1
- **Answer:** False. The HTML file itself requires one HTTP request, and each embedded image generates additional requests. If three images are included, a total of four requests occur.

### Question 2
- **Answer:** True. This mechanism improves efficiency by reducing the overhead of opening new connections for each request.

### Question 3
- **Answer:** False. Custom application-layer protocols can be designed and implemented over TCP; HTTP is not the sole option.

### Question 4
- **Answer:** False. HTTP is inherently stateless, meaning it does not maintain session data between client and server interactions by default.

### Question 5
- **Answer:** False. Root DNS servers provide referrals to authoritative servers but do not oversee the complete DNS hierarchy.

---

## Problem 2: Differences Between HTTP Versions

### Comparison Table

| Feature               | HTTP/1.0 | HTTP/1.1 |
|----------------------|---------|---------|
| **Persistent Connections** | Requires reopening for each request | Default behavior |
| **Pipelining**       | Not supported | Supported, allows multiple requests before responses |
| **Host Header**      | Optional | Mandatory, enabling virtual hosting |

---

## Problem 3: Domain Name Resolution

### Process Overview
1. **DNS Lookup:** The client queries a DNS server to resolve a domain name into an IP address.
2. **Connection Initiation:** Once resolved, the client sends an HTTP/HTTPS request to retrieve the content.

---

## Problem 4: DNS Query Types

### Iterative Query
- The client requests a DNS resolution.
- If the server lacks the answer, it provides a referral to another DNS server.
- The client continues querying until it gets a final response or an error.

### Recursive Query
- The client requests a full resolution from a DNS server.
- The server queries other DNS servers on behalf of the client.
- The client receives a final answer or an error message.

---

## Problem 5: Manual DNS Lookup with `dig`

### Steps:
1. **Query a Root Server:**
   ```bash
   dig @a.root-servers.net www.cs.stonybrook.edu
   ```
   <img width="626" alt="Screenshot 2025-02-13 at 9 15 29 PM" src="https://github.com/user-attachments/assets/614abf6b-6194-41a2-9eb6-49fd26aa0992" />

2. **Query a TLD Server:**
   ```bash
   dig @b.edu-servers.net www.cs.stonybrook.edu
   ```
   <img width="602" alt="Screenshot 2025-02-13 at 9 15 58 PM" src="https://github.com/user-attachments/assets/5c3c53c4-7371-4fc5-81b3-7b83cdbb6a79" />

   **Authority Section Response:**
   - `nocnoc.stonybrook.edu`
   - `whoisthere.stonybrook.edu`
   - `mewho.stonybrook.edu`

3. **Query an Authoritative Server:**
   ```bash
   dig @nocnoc.stonybrook.edu www.cs.stonybrook.edu
   ```
   <img width="629" alt="Screenshot 2025-02-13 at 9 16 24 PM" src="https://github.com/user-attachments/assets/2c26ad89-bbbc-473e-bc6a-756abf20c4cd" />

   **Response:** `www.cs.stonybrook.edu` is a CNAME for `live-compscid9sbu.pantheonsite.io`.

4. **Resolve the Final Host:**
   ```bash
   dig live-compscid9sbu.pantheonsite.io
   ```
   <img width="553" alt="Screenshot 2025-02-13 at 9 16 56 PM" src="https://github.com/user-attachments/assets/1c4a1e7c-3aeb-4809-9cf2-4b741dbc65bf" /><br>
   **Result:** The final IP address is `23.185.0.4`.

