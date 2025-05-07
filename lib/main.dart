import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        hintColor: Colors.grey[400],
      ),
      home: const ProfileCard(), // Widget utama yang menampilkan kartu profil
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model data profil
class Profile {
  final String name;
  final String bio;
  final int age;
  final String location;

  Profile({
    required this.name,
    required this.bio,
    this.age = 25,
    this.location = 'Surakarta',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Profile &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// Halaman profil pengguna
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Nama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Lingga', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Bio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Suka Berang dan Camping.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Lokasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Yogyakarta', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  },
                  child: const Text('Kembali ke Kenalan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman chat dengan pengguna pertama di favorit
                    final favoriteList = ModalRoute.of(context)?.settings.arguments as List<Profile>?;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatListPage(
                          otherUser: favoriteList != null && favoriteList.isNotEmpty
                              ? favoriteList.first
                              : Profile(name: 'Tidak Ada Pengguna', bio: '', age: 0, location: ''),
                        ),
                      ),
                    );
                  },
                  child: const Text('Chat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman daftar chat
class ChatListPage extends StatefulWidget {
  final Profile otherUser;
  const ChatListPage({super.key, required this.otherUser});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _chatInputController = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  // Mengirim pesan
  void _sendMessage() {
    if (_chatInputController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add('Anda: ${_chatInputController.text.trim()}');
        _messages.add('${widget.otherUser.name}: ${_chatInputController.text.trim()}');
        _chatInputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan ${widget.otherUser.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message, style: const TextStyle(fontSize: 16)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatInputController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman daftar favorit
class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  late List<Profile> _favoriteProfiles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<Profile>? favorites =
    ModalRoute.of(context)?.settings.arguments as List<Profile>?;
    _favoriteProfiles = favorites ?? [];
  }

  // Menghapus profil dari favorit
  void _removeFromFavorites(Profile profile) {
    setState(() {
      _favoriteProfiles.remove(profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Kamu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListPage(
                    otherUser: _favoriteProfiles.isNotEmpty
                        ? _favoriteProfiles.first
                        : Profile(
                        name: "No User",
                        bio: "No bio",
                        age: 0,
                        location: "No location"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _favoriteProfiles.isEmpty
          ? const Center(
        child: Text('Belum ada yang difavoritkan.', style: TextStyle(fontSize: 18)),
      )
          : ListView.builder(
        itemCount: _favoriteProfiles.length,
        itemBuilder: (context, index) {
          final profile = _favoriteProfiles[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatListPage(otherUser: profile),
                        ),
                      );
                    },
                    child: Text(profile.name, style: const TextStyle(fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeFromFavorites(profile),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget utama yang menampilkan kartu profil yang dapat digeser
class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final List<Profile> _profiles = [
    Profile(name: 'Ayu', bio: 'Suka membaca buku dan hiking.', age: 23, location: 'Yogyakarta'),
    Profile(name: 'Budi', bio: 'Pecinta kopi dan bermain gitar.', age: 28, location: 'Semarang'),
    Profile(name: 'Citra', bio: 'Menyukai traveling dan kuliner.', age: 21, location: 'Bandung'),
    Profile(name: 'Dedi', bio: 'Gemar berolahraga dan memasak.', age: 26, location: 'Jakarta'),
  ];

  int _currentIndex = 0;
  final List<Profile> _favorites = [];
  String _favoriteMessage = '';
  bool _isFavorite = false;

  // Pindah ke profil berikutnya
  void _nextProfile() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _profiles.length;
      _favoriteMessage = '';
      _isFavorite = false;
    });
  }

  // Menambahkan profil ke daftar favorit
  void _addToFavorites() {
    setState(() {
      final currentProfile = _profiles[_currentIndex];
      if (!_favorites.contains(currentProfile)) {
        _favorites.add(currentProfile);
        _favoriteMessage = 'Favorit Ditambahkan!';
        _isFavorite = true;
        // Menghilangkan pesan favorit setelah beberapa detik
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _favoriteMessage = '';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profiles[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kenalan Yuk!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline), // Ke halaman profil saya
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfilePage(),
                  settings: RouteSettings(arguments: _favorites), // Kirim data favorit
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite), // Ke halaman favorit
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteListPage(),
                  settings: RouteSettings(arguments: _favorites), // Kirim data favorit
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(profile.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${profile.age} Tahun',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 5),
                      Text(profile.location,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(profile.bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 48),
                        onPressed: _nextProfile,
                      ),
                      ElevatedButton(
                        onPressed: _nextProfile,
                        child: const Text('Lanjut Kenalan'),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: _isFavorite ? Colors.pink : Colors.grey,
                          size: 48,
                        ),
                        onPressed: _addToFavorites,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_favoriteMessage.isNotEmpty)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _favoriteMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}