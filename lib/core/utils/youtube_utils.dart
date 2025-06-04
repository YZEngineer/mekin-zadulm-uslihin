class YoutubeUtils {
  static String? extractVideoId(String url) {
    if (url.isEmpty) return null;

    // Handle youtu.be short URLs
    if (url.contains('youtu.be')) {
      final uri = Uri.parse(url);
      final id = uri.pathSegments.first;
      return id.length == 11 ? id : null;
    }

    // Handle youtube.com URLs
    if (url.contains('youtube.com')) {
      final uri = Uri.parse(url);
      final id = uri.queryParameters['v'];
      return id?.length == 11 ? id : null;
    }

    // If the input is already a video ID (no URL format)
    if (url.length == 11 && !url.contains('/') && !url.contains('.')) {
      return url;
    }

    return null;
  }

  static bool isValidYoutubeUrl(String url) {
    if (url.isEmpty) return false;

    // Check if it's a valid video ID
    if (url.length == 11 && !url.contains('/') && !url.contains('.')) {
      return true;
    }

    // Check youtu.be format
    if (url.contains('youtu.be')) {
      try {
        final uri = Uri.parse(url);
        final id = uri.pathSegments.first;
        return id.length == 11;
      } catch (e) {
        return false;
      }
    }

    // Check youtube.com format
    if (url.contains('youtube.com')) {
      try {
        final uri = Uri.parse(url);
        final id = uri.queryParameters['v'];
        return id?.length == 11 ?? false;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  static String? getErrorMessage(String url) {
    if (url.isEmpty) {
      return 'الرجاء إدخال رابط الفيديو';
    }

    if (!url.contains('youtube.com') &&
        !url.contains('youtu.be') &&
        url.length != 11) {
      return 'الرجاء إدخال رابط يوتيوب صحيح';
    }

    if (!isValidYoutubeUrl(url)) {
      return 'رابط الفيديو غير صالح';
    }

    return null;
  }
}
