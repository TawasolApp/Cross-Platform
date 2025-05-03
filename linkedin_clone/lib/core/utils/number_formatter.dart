String formatNumber(int number) {
  if (number >= 1000000000) {
    return '${(number ~/ 100000000).toString()}B+'; // Nearest 100M+
  } else if (number >= 1000000) {
    return '${(number ~/ 100000).toString()}M+'; // Nearest 100K+ (to keep two digits)
  } else if (number >= 10000) {
    return '${(number ~/ 1000) * 10}K+'; // Nearest 10K+
  } else if (number >= 1000) {
    return '${(number ~/ 1000)}K+'; // Normal 1K+
  } else {
    return number.toString(); // Less than 1K, show the full number
  }
}
