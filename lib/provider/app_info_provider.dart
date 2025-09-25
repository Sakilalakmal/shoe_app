class AppInfoModel {
  final AppInfo appInfo;
  final Vision vision;
  final List<Feature> userFeatures;
  final List<Feature> vendorFeatures;
  final Technologies technologies;
  final Company company;
  final Legal legal;

  AppInfoModel({
    required this.appInfo,
    required this.vision,
    required this.userFeatures,
    required this.vendorFeatures,
    required this.technologies,
    required this.company,
    required this.legal,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      appInfo: AppInfo.fromJson(json['appInfo']),
      vision: Vision.fromJson(json['vision']),
      userFeatures: (json['userFeatures'] as List)
          .map((feature) => Feature.fromJson(feature))
          .toList(),
      vendorFeatures: (json['vendorFeatures'] as List)
          .map((feature) => Feature.fromJson(feature))
          .toList(),
      technologies: Technologies.fromJson(json['technologies']),
      company: Company.fromJson(json['company']),
      legal: Legal.fromJson(json['legal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appInfo': appInfo.toJson(),
      'vision': vision.toJson(),
      'userFeatures': userFeatures.map((f) => f.toJson()).toList(),
      'vendorFeatures': vendorFeatures.map((f) => f.toJson()).toList(),
      'technologies': technologies.toJson(),
      'company': company.toJson(),
      'legal': legal.toJson(),
    };
  }
}

class AppInfo {
  final String appName;
  final String version;
  final String tagline;
  final String description;

  AppInfo({
    required this.appName,
    required this.version,
    required this.tagline,
    required this.description,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['appName'] ?? '',
      version: json['version'] ?? '',
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'version': version,
      'tagline': tagline,
      'description': description,
    };
  }
}

class Vision {
  final String title;
  final String description;
  final String mission;

  Vision({
    required this.title,
    required this.description,
    required this.mission,
  });

  factory Vision.fromJson(Map<String, dynamic> json) {
    return Vision(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mission: json['mission'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'mission': mission,
    };
  }
}

class Feature {
  final String title;
  final String description;
  final String icon;

  Feature({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}

class Technologies {
  final String title;
  final String description;
  final List<TechStack> stack;

  Technologies({
    required this.title,
    required this.description,
    required this.stack,
  });

  factory Technologies.fromJson(Map<String, dynamic> json) {
    return Technologies(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      stack: (json['stack'] as List)
          .map((tech) => TechStack.fromJson(tech))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'stack': stack.map((t) => t.toJson()).toList(),
    };
  }
}

class TechStack {
  final String name;
  final String description;
  final String version;

  TechStack({
    required this.name,
    required this.description,
    required this.version,
  });

  factory TechStack.fromJson(Map<String, dynamic> json) {
    return TechStack(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      version: json['version'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'version': version,
    };
  }
}

class Company {
  final String name;
  final String tagline;
  final String description;
  final String founded;
  final String copyright;
  final Contact contact;
  final SocialMedia socialMedia;

  Company({
    required this.name,
    required this.tagline,
    required this.description,
    required this.founded,
    required this.copyright,
    required this.contact,
    required this.socialMedia,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      founded: json['founded'] ?? '',
      copyright: json['copyright'] ?? '',
      contact: Contact.fromJson(json['contact']),
      socialMedia: SocialMedia.fromJson(json['socialMedia']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'description': description,
      'founded': founded,
      'copyright': copyright,
      'contact': contact.toJson(),
      'socialMedia': socialMedia.toJson(),
    };
  }
}

class Contact {
  final String email;
  final String website;
  final String phone;

  Contact({
    required this.email,
    required this.website,
    required this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'website': website,
      'phone': phone,
    };
  }
}

class SocialMedia {
  final String twitter;
  final String linkedin;
  final String github;

  SocialMedia({
    required this.twitter,
    required this.linkedin,
    required this.github,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      twitter: json['twitter'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'twitter': twitter,
      'linkedin': linkedin,
      'github': github,
    };
  }
}

class Legal {
  final String privacyPolicy;
  final String termsOfService;
  final String disclaimer;

  Legal({
    required this.privacyPolicy,
    required this.termsOfService,
    required this.disclaimer,
  });

  factory Legal.fromJson(Map<String, dynamic> json) {
    return Legal(
      privacyPolicy: json['privacyPolicy'] ?? '',
      termsOfService: json['termsOfService'] ?? '',
      disclaimer: json['disclaimer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacyPolicy': privacyPolicy,
      'termsOfService': termsOfService,
      'disclaimer': disclaimer,
    };
  }
}