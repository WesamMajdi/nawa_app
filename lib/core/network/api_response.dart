class PageInfo {
  final String? cursor;
  final String? nextCursor;
  final bool hasNext;

  PageInfo({this.cursor, this.nextCursor, this.hasNext = false});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      cursor: json['cursor'] as String?,
      nextCursor: json['nextCursor'] as String?,
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final PageInfo pageInfo;

  PaginatedResponse({required this.items, required this.pageInfo});
}
