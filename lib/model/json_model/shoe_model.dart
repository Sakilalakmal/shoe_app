class AboutUs {
  final String appLogoUrl; // URL for the app logo
  final String appName; // App name
  final String aboutUsDescription; // The description of the app
  final String missionStatement; // App's mission statement
  final List<String> socialMediaLinks; // Social media links (e.g., Facebook, Instagram, etc.)

  // Constructor
  AboutUs({
    required this.appLogoUrl,
    required this.appName,
    required this.aboutUsDescription,
    required this.missionStatement,
    required this.socialMediaLinks,
  });

  // From JSON (deserialization)
  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      appLogoUrl: json['appLogoUrl'] ?? '', // App logo URL
      appName: json['appName'] ?? '', // App name
      aboutUsDescription: json['aboutUsDescription'] ?? '', // About Us description
      missionStatement: json['missionStatement'] ?? '', // Mission statement
      socialMediaLinks: List<String>.from(json['socialMediaLinks'] ?? []), // List of social media links
    );
  }

  // To JSON (serialization)
  Map<String, dynamic> toJson() {
    return {
      'appLogoUrl': appLogoUrl,
      'appName': appName,
      'aboutUsDescription': aboutUsDescription,
      'missionStatement': missionStatement,
      'socialMediaLinks': socialMediaLinks,
    };
  }
}
