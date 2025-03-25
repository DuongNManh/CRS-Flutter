class ApiResponse<T> {
  final int statusCode;
  final String message;
  final String? reason;
  final bool isSuccess;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.reason,
    required this.isSuccess,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Map<String, dynamic>) fromJsonT,
  ) => ApiResponse(
    statusCode: json['status_code'],
    message: json['message'],
    reason: json['reason'] ?? "",
    isSuccess: json['is_success'],
    data: json['data'] != null ? fromJsonT(json['data']) : null,
  );
}

class PaginationMeta {
  final int totalPages;
  final int totalItems;
  final int currentPage;
  final int pageSize;

  PaginationMeta({
    required this.totalPages,
    required this.totalItems,
    required this.currentPage,
    required this.pageSize,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalPages: json['total_pages'],
      totalItems: json['total_items'],
      currentPage: json['current_page'],
      pageSize: json['page_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_pages': totalPages,
      'total_items': totalItems,
      'current_page': currentPage,
      'page_size': pageSize,
    };
  }
}

class PagingResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  PagingResponse({required this.items, required this.meta});

  factory PagingResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagingResponse(
      items: (json['items'] as List).map((item) => fromJsonT(item)).toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => (item as dynamic).toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
