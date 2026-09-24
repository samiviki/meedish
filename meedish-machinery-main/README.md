# Meedish Machinery - Construction Equipment Marketplace

A modern, multi-user marketplace platform for buying and renting construction machinery with partner registrations, secure authentication, and real-time listings.

## Features

- **Partner Registration**: Companies register as partners with approval workflow
- **Machine Listings**: Partners post equipment for rent or sale
- **Customer Browsing**: Customers search and filter machinery
- **Wishlist**: Save desired machines for later reference
- **Booking**: Complete rental booking workflow with multi-step form
- **Machine Inquiries**: Request machines not currently available
- **Order Tracking**: Customers view their orders and status
- **Admin Dashboards**: Partner and Super Admin dashboards for management
- **Multi-language**: English and Amharic support
- **Secure Auth**: Supabase Auth with role-based access control

## Tech Stack

- **Frontend**: HTML5, CSS3 (Tailwind), JavaScript (vanilla)
- **Backend**: Supabase (Firebase alternative)
- **Database**: PostgreSQL via Supabase
- **Authentication**: Supabase Auth with Row-Level Security (RLS)
- **Storage**: Supabase Storage for images
- **Hosting**: Static site + Supabase backend

## Project Structure

```
meedish-machinery-main/
├── index.html                          # Main marketplace page
├── admin.html                          # Partner dashboard
├── super_admin_dashboard.html          # Super admin panel
├── signup.html                         # Partner registration
├── js/
│   ├── config-loader.js                # Load Supabase config from /api/config
│   ├── supabase-client.js              # Centralized Supabase client init
│   ├── auth.js                         # Auth helper functions
│   ├── config.js                       # Old (deprecated)
├── api/
│   └── config.js                       # Backend endpoint for Supabase config
├── tests/
│   └── smoke-test.html                 # Basic functionality tests
├── orders_rls_setup.sql                # RLS policies for orders table
├── supabase_setup.sql                  # RLS policies for inquiries table
└── booking_wishlist_functions.js       # Booking/wishlist logic
```

## Database Schema

### Users Table
```sql
id (uuid, PK)
auth_uid (text) -- Links to Supabase Auth user.id
email (text, unique)
full_name (text)
company_name (text)
role (text) -- 'customer', 'partner', 'admin', 'super_admin'
status (text) -- 'pending', 'approved', 'blocked'
created_at (timestamp)
```

### Machines Table
```sql
id (uuid, PK)
partner_id (uuid, FK -> users.id)
title (text)
description (text)
category (text)
listing_type (text) -- 'rent', 'sale'
price_per_day (numeric, nullable)
price (numeric, nullable)
condition (text) -- 'new', 'excellent', 'good', 'fair'
location (text)
status (text) -- 'available', 'rented', 'sold'
image_urls (jsonb, array)
created_at (timestamp)
updated_at (timestamp)
```

### Orders Table
```sql
id (uuid, PK)
machine_id (uuid, FK)
buyer_id (uuid, FK -> users.id)
seller_id (uuid, FK -> users.id)
listing_type (text)
rental_start (timestamp, nullable)
rental_end (timestamp, nullable)
total_amount (numeric)
status (text) -- 'pending', 'confirmed', 'completed', 'cancelled'
payment_status (text) -- 'pending', 'paid'
created_at (timestamp)
```

### Wishlist Table
```sql
id (uuid, PK)
user_id (uuid, FK -> users.id)
machine_id (uuid, FK -> machines.id)
created_at (timestamp)
```

### Machine Inquiries Table
```sql
id (uuid, PK)
user_id (uuid, FK -> users.id)
listing_type (text) -- 'rent', 'sale'
machine_type (text)
brand_preference (text)
model_year (text)
min_price (numeric)
max_price (numeric)
specifications (text)
start_date (date)
duration (text)
notes (text)
status (text) -- 'pending', 'reviewed', 'closed'
created_at (timestamp)
```

## Installation & Setup

### 1. Prerequisites
- Supabase project (free tier at supabase.com)
- Node.js or Python (optional, for running a local server)
- Git

### 2. Clone the Repository
```bash
git clone https://github.com/yourusername/meedish-machinery.git
cd meedish-machinery-main
```

### 3. Set Up Environment Variables
Create a `.env` file in the project root (if using a backend server):
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### 4. Set Up Supabase
1. Create a Supabase project at supabase.com
2. Create the tables using the schema above (use SQL editor in Supabase dashboard)
3. Enable Row Level Security (RLS) on all tables
4. Run the RLS policies:
   ```bash
   # In Supabase SQL Editor, run:
   \i orders_rls_setup.sql
   \i supabase_setup.sql
   ```

### 5. Configure API Endpoint
Update `/api/config.js` to return your Supabase URL and anon key:
```javascript
export default function handler(req, res) {
    res.status(200).json({
        SUPABASE_URL: process.env.SUPABASE_URL,
        SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY,
    });
}
```

Or if using a static deployment, create a config file:
```javascript
// js/config.json (create manually)
{
    "SUPABASE_URL": "https://...",
    "SUPABASE_ANON_KEY": "..."
}
```

### 6. Run Locally (Optional)
If you have a Node.js backend:
```bash
npm install
npm run dev
```

Or serve with Python:
```bash
python -m http.server 8000
```

Visit `http://localhost:8000/index.html`

## Architecture Notes

### Authentication Flow

1. **Partner Signup**: 
   - User fills signup form
   - `auth.signUp(email, password)` creates Supabase Auth user
   - Partner profile inserted into `users` table with `role='partner'` and `status='pending'`
   - Super Admin approves in dashboard

2. **Login**:
   - Customer or approved Partner logs in via `auth.signIn(email, password)`
   - Session stored in browser via Supabase persistence

3. **Guest Access**:
   - Guests can browse machines (no auth required)
   - Wishlist and orders require authentication

### RLS Policies

All tables use Row-Level Security:
- **Orders**: Users can only see/create orders where they are `buyer_id` or `seller_id`
- **Wishlist**: Users can only manage their own wishlist (user_id = auth.uid())
- **Machines**: Public read, only partners can create/update their own
- **Inquiries**: Only authenticated users can create, owners can view/update

## Key Files & Functions

### `js/supabase-client.js`
```javascript
initSupabaseClient()     // Initialize Supabase with config
getSupabase()            // Get existing Supabase instance
```

### `js/auth.js`
```javascript
auth.signUp(email, password)           // Register new user
auth.signIn(email, password)           // Login
auth.signOut()                         // Logout
auth.getSession()                      // Get current session
auth.onAuthStateChange(callback)       // Listen for auth changes
```

### `booking_wishlist_functions.js`
```javascript
toggleWishlist(machineId)              // Add/remove from wishlist
openCompleteBookingModal(machineId)    // Open booking form
submitBooking()                        // Submit order
```

### `inquiry_functions.js`
```javascript
openInquiryModal()                     // Open request form
submitInquiry()                        // Submit machine inquiry
```

## Testing

Run smoke tests:
1. Open `tests/smoke-test.html` in a browser
2. Check that all tests pass (green)
3. Tests validate:
   - Config loading
   - Supabase client initialization
   - Auth helpers availability
   - RLS policies (guest access blocked for private tables)

## Deployment

### Option A: Vercel / Netlify (Static + Serverless)
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel
```

Set environment variables in Vercel dashboard:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

### Option B: Traditional Hosting + Supabase
1. Upload files to web server or S3
2. Update `/api/config.js` endpoint (if using backend)
3. Ensure CORS is configured for Supabase

### Option C: Docker (optional)
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
```

## Contributing

1. Create a feature branch
2. Make changes
3. Test locally
4. Submit PR

## Security Considerations

- ✅ **No hardcoded secrets**: Config loaded from environment variables
- ✅ **Passwords not stored**: Uses Supabase Auth with bcrypt hashing
- ✅ **RLS enforced**: All sensitive queries require authentication
- ✅ **Email validation**: Input validation on forms
- ⚠️ **TODO**: Add CSRF protection
- ⚠️ **TODO**: Add rate limiting on auth endpoints
- ⚠️ **TODO**: Add logging/monitoring

## Known Issues & TODO

- [ ] Admin role-based policies (currently uses authenticated role for all admins)
- [ ] Email verification for partner signup
- [ ] Payment integration (currently no payment processing)
- [ ] Real-time notifications (order status updates)
- [ ] Machine unavailability calendar
- [ ] Map view with filters
- [ ] Chat/messaging between partners and customers
- [ ] Review and rating system

## Support

For issues or questions:
- Email: support@meedishmachinery.com
- GitHub Issues: https://github.com/yourusername/meedish-machinery/issues

## License

MIT License - see LICENSE file

---

**Last Updated**: 2026-07-08  
**Version**: 2.0 (Auth & RLS Refactor)
