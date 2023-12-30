
// Country code to flag emoji
String countryCodeToEmoji(String countryCode) => countryCode
    .toUpperCase()
    .replaceAllMapped(RegExp(r'[A-Z]'), (match) =>
        String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));