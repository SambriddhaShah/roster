class ApiUrl {
  static const String baseUrl = "http://69.62.123.60:3000/api/v1";
  static const String imageUrl = "http://69.62.123.60:3000";
  // static const String baseUrl = "http://192.168.101.54:3000/api/v1";
  // static const String imageUrl = "http://192.168.101.54:3000";
  // static const String baseUrl = "https://hcs.omegaincorporations.com/api/v1";
  // static const String imageUrl = "https://hcs.omegaincorporations.com";
  static const String login = "$baseUrl/candidate/login";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const String getCandidate = "$baseUrl/candidate/";
  static const String logout = "$baseUrl/candidate/logout";
  static const String candidateStage = "$baseUrl/ats/jobs/";
  static const String uploadFile = "$baseUrl/candidate/file";
  static const String documentUpload = "$baseUrl/candidate/document";
  static const String getDocuments = "$baseUrl/candidate/document/";
  static const String uplaodAssessment = "$baseUrl/candidate/";
  static const String uploadOfferLetter = "$baseUrl/offer-letter/";
}
