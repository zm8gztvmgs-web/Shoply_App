SHOPLY — JSON catalog patch (28 Oct 2026)

BACK UP YOUR PROJECT BEFORE APPLYING.

1. Unzip this patch into the Shoply_App project root, merging folders and replacing ONLY the listed files.
2. Run: flutter pub get
3. Stop the running app and launch again (full restart, not hot reload).
4. Check Home Trending (5 products), Categories (5), each category (2), and images.
5. Check favorites and cart with a NEW product, then remove it.

Data source: supplied professor JSON (10 products, 5 categories). No Firebase catalog writes.
Auth, favorites and cart remain Firebase-backed. Existing favorites/cart records are not migrated.
The JSON omits categoryId; product-to-category mapping uses the ten supplied IDs.
The supplied Beauty category thumbnail points to red-lipstick while the Beauty products are fragrances; this URL was preserved exactly.
The existing sales banner is unchanged.

LIMITATIONS: Flutter SDK and iOS simulator are unavailable in this environment; runtime compilation and end-to-end tests must be performed on your Mac.
