Simple Dating App (Flutter)
Aplikasi ini merupakan prototype aplikasi dating sederhana berbasis Flutter, yang memungkinkan pengguna untuk berkenalan, menyimpan favorit, dan mengirim pesan singkat antar profil.

Daftar Halaman
1. ProfileCard (Halaman Utama)
   Halaman utama aplikasi yang menampilkan satu per satu profil pengguna secara geser (swipe-like).

Widget utama:

Scaffold

AppBar

Container

IconButton

ElevatedButton

Stack (untuk menampilkan pesan "Favorit Ditambahkan")

2. MyProfilePage (Profil Saya)
   Halaman yang menampilkan data profil pengguna saat ini (statis).

Widget utama:

Scaffold

AppBar

CircleAvatar

Text

ElevatedButton

Column, Row

3. FavoriteListPage (Daftar Favorit)
   Menampilkan daftar profil yang ditandai sebagai favorit oleh pengguna.

Widget utama:

Scaffold

AppBar + IconButton (menuju ke halaman chat)

ListView.builder

Card

InkWell

IconButton

4. ChatListPage (Halaman Chat)
   Simulasi fitur chat sederhana dengan pengguna lain.

Widget utama:

Scaffold

AppBar

ListView.builder (menampilkan pesan)

TextField

IconButton

Widget Utama yang Digunakan

Widget	Deskripsi
Scaffold	Struktur dasar halaman (AppBar, body, dll.)
AppBar	Navigasi atas pada setiap halaman
ListView.builder	Menampilkan daftar (pesan, daftar favorit) secara dinamis
TextField	Input pesan chat
IconButton	Tombol dengan ikon (favorit, kirim pesan, hapus favorit, dll.)
ElevatedButton	Tombol aksi utama (navigasi, lanjut profil, dll.)
CircleAvatar	Menampilkan foto pengguna (placeholder dengan ikon)
Stack	Untuk menampilkan notifikasi sementara (misalnya "Favorit Ditambahkan!")
Navigator	Navigasi antar halaman dengan argumen

Struktur Navigasi
ProfileCard
├── MyProfilePage (Profil Saya)
│   └── ChatListPage (jika ada favorit)
├── FavoriteListPage
│   └── ChatListPage (per pengguna favorit)
└── ChatListPage (langsung dari Favorite atau Profil)

Catatan
1. Data profil dan pesan disimpan secara lokal (tidak ada backend).
2. Desain masih bersifat dasar
