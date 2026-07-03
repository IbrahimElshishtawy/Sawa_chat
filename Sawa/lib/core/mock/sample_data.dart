class SampleChat {
  final String title;
  final String subtitle;
  final String time;
  final String avatarUrl;
  final bool isGroup;
  final bool isChannel;
  final int unreadCount;

  SampleChat({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.avatarUrl,
    this.isGroup = false,
    this.isChannel = false,
    this.unreadCount = 0,
  });
}

class SampleStory {
  final String name;
  final String avatarUrl;
  final bool isYourStory;

  SampleStory({
    required this.name,
    required this.avatarUrl,
    this.isYourStory = false,
  });
}

class SamplePost {
  final String username;
  final String avatarUrl;
  final String timeAgo;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;

  SamplePost({
    required this.username,
    required this.avatarUrl,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}

final sampleChats = <SampleChat>[
  SampleChat(
    title: 'Amira Hassan',
    subtitle: 'تمام، حرفع الملفات بعد شوية.',
    time: '9:45 AM',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
    unreadCount: 2,
  ),
  SampleChat(
    title: 'Flutter Devs Group',
    subtitle: 'اجتماع الساعه 6 مساءً في القناة.',
    time: '8:12 AM',
    avatarUrl: 'https://i.pravatar.cc/150?img=45',
    isGroup: true,
    unreadCount: 5,
  ),
  SampleChat(
    title: 'Sara Mahmoud',
    subtitle: 'هذا هو الرابط الذي طلبته.',
    time: 'Yesterday',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  SampleChat(
    title: 'Official Channel',
    subtitle: 'تم نشر تحديث جديد اليوم.',
    time: 'Mon',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    isChannel: true,
  ),
  SampleChat(
    title: 'Khaled Adel',
    subtitle: 'مرحبا! كيف حالك؟',
    time: 'Sun',
    avatarUrl: 'https://i.pravatar.cc/150?img=27',
    unreadCount: 1,
  ),
  SampleChat(
    title: 'Design Team',
    subtitle: 'تم إرسال التصميم الجديد للمراجعة.',
    time: 'Fri',
    avatarUrl: 'https://i.pravatar.cc/150?img=53',
    isGroup: true,
  ),
];

final sampleStories = <SampleStory>[
  SampleStory(
    name: 'Your Story',
    avatarUrl: 'https://i.pravatar.cc/150?img=10',
    isYourStory: true,
  ),
  SampleStory(name: 'Heba', avatarUrl: 'https://i.pravatar.cc/150?img=21'),
  SampleStory(name: 'Nora', avatarUrl: 'https://i.pravatar.cc/150?img=16'),
  SampleStory(name: 'Mahmoud', avatarUrl: 'https://i.pravatar.cc/150?img=18'),
  SampleStory(name: 'Laila', avatarUrl: 'https://i.pravatar.cc/150?img=20'),
];

final samplePosts = <SamplePost>[
  SamplePost(
    username: 'Amira H.',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
    timeAgo: '2h',
    content:
        'قمت بمشاركة بعض النصائح الجديدة لتطوير واجهات فلاتر، جربوها وشاركوني رأيكم.',
    imageUrl: 'https://picsum.photos/seed/post1/400/200',
    likes: 1240,
    comments: 45,
    shares: 12,
  ),
  SamplePost(
    username: 'Sara M.',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    timeAgo: '4h',
    content:
        'اليوم كان يوم رائع للعمل على تطبيق دردشة جديد، وواجهنا تحديات متعة.',
    imageUrl: 'https://picsum.photos/seed/post2/400/200',
    likes: 860,
    comments: 30,
    shares: 8,
  ),
  SamplePost(
    username: 'Khaled A.',
    avatarUrl: 'https://i.pravatar.cc/150?img=27',
    timeAgo: '8h',
    content: 'أضفت ميزة البحث داخل المحادثات، وهذا يساعد المستخدمين كثيرا.',
    imageUrl: 'https://picsum.photos/seed/post3/400/200',
    likes: 530,
    comments: 18,
    shares: 5,
  ),
];
