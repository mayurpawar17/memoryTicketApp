class MemoryModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final String description;
  final String imageUrl;
  final String category;
  final bool isFavorite;

  const MemoryModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });
}

const List<MemoryModel> dummyMemories = [
  MemoryModel(
    id: '1',
    title: 'Goa Golden Hour',
    location: 'Baga Beach, Goa',
    date: '19 July 2026',
    description: 'Best sunset I\'ve ever seen with my favorite people.',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
    category: 'Travel',
    isFavorite: true,
  ),
  MemoryModel(
    id: '2',
    title: 'Neapolitan Perfection',
    location: 'Da Michele, Naples',
    date: '14 July 2026',
    description: 'Wood-fired crust, fresh basil, absolute bliss.',
    imageUrl:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    category: 'Food',
  ),
  MemoryModel(
    id: '3',
    title: '25th Birthday Bash',
    location: 'The Rooftop Lounge',
    date: '08 July 2026',
    description: 'Midnight cake cuts and laughing until our stomachs hurt.',
    imageUrl:
        'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
    category: 'Friends',
  ),
  MemoryModel(
    id: '4',
    title: 'Into the Clouds',
    location: 'Anamudi Peak, Munnar',
    date: '30 June 2026',
    description:
        'Woke up at 4 AM. The fog rolling over the valley was surreal.',
    imageUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
    category: 'Nature',
  ),
  MemoryModel(
    id: '5',
    title: 'Coldplay Live Concert',
    location: 'DY Patil Stadium',
    date: '18 June 2026',
    description: 'A stadium lit up by a sea of yellow wristbands.',
    imageUrl:
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
    category: 'Friends',
    isFavorite: true,
  ),
];
