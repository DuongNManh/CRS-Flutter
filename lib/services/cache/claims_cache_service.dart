import 'package:learning_android_1/models/claim_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ClaimsCacheService {
  static final ClaimsCacheService _instance = ClaimsCacheService._internal();
  factory ClaimsCacheService() => _instance;

  SharedPreferences? _prefs;
  bool _initialized = false;

  ClaimsCacheService._internal();

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _loadPersistedState();
      _initialized = true;
    }
  }

  // Cache keys
  static const String _filterStateKey = 'claims_filter_state';
  static const String _claimsDataKey = 'claims_data';

  // In-memory cache for faster access
  final Map<String, _CacheData> _cache = {};

  // Current view state
  String? currentStatus;
  DateTime? currentStartDate;
  DateTime? currentEndDate;
  int currentPage = 1;
  int? totalPages;
  double? scrollPosition;

  void _loadPersistedState() {
    if (_prefs == null) return;
    final filterStateJson = _prefs!.getString(_filterStateKey);
    if (filterStateJson != null) {
      final filterState = json.decode(filterStateJson);
      currentStatus = filterState['status'];
      currentStartDate =
          filterState['startDate'] != null
              ? DateTime.parse(filterState['startDate'])
              : null;
      currentEndDate =
          filterState['endDate'] != null
              ? DateTime.parse(filterState['endDate'])
              : null;
      currentPage = filterState['currentPage'] ?? 1;
      totalPages = filterState['totalPages'];
      scrollPosition = filterState['scrollPosition']?.toDouble();
    }

    // Load cached claims data
    final claimsDataJson = _prefs!.getString(_claimsDataKey);
    if (claimsDataJson != null) {
      final claimsData = json.decode(claimsDataJson);
      _deserializeCache(claimsData);
    }
  }

  Future<void> _persistState() async {
    if (_prefs == null) return;
    final filterState = {
      'status': currentStatus,
      'startDate': currentStartDate?.toIso8601String(),
      'endDate': currentEndDate?.toIso8601String(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'scrollPosition': scrollPosition,
    };
    await _prefs!.setString(_filterStateKey, json.encode(filterState));

    // Persist claims cache
    final serializedCache = _serializeCache();
    await _prefs!.setString(_claimsDataKey, json.encode(serializedCache));
  }

  Map<String, dynamic> _serializeCache() {
    final serializedCache = <String, dynamic>{};
    _cache.forEach((key, cacheData) {
      serializedCache[key] = {
        'claims': cacheData.claims.map(
          (page, claims) => MapEntry(
            page.toString(),
            claims.map((claim) => claim.toJson()).toList(),
          ),
        ),
        'totalPages': cacheData.totalPages,
        'lastUpdated': cacheData.lastUpdated.toIso8601String(),
      };
    });
    return serializedCache;
  }

  void _deserializeCache(Map<String, dynamic> serializedCache) {
    serializedCache.forEach((key, value) {
      final cacheData = _CacheData();
      final claimsMap = value['claims'] as Map<String, dynamic>;

      claimsMap.forEach((pageStr, claimsList) {
        final page = int.parse(pageStr);
        final claims =
            (claimsList as List)
                .map(
                  (claimJson) => GetClaimResponse.fromJson(
                    claimJson as Map<String, dynamic>,
                  ),
                )
                .toList();
        cacheData.claims[page] = claims;
      });

      cacheData.totalPages = value['totalPages'];
      cacheData.lastUpdated = DateTime.parse(value['lastUpdated']);
      _cache[key] = cacheData;
    });
  }

  String _generateCacheKey({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return '${status ?? 'all'}_'
        '${startDate?.toIso8601String() ?? 'nostart'}_'
        '${endDate?.toIso8601String() ?? 'noend'}';
  }

  void cacheClaimsData({
    required List<GetClaimResponse> claims,
    required int page,
    required int totalPages,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final key = _generateCacheKey(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    if (!_cache.containsKey(key)) {
      _cache[key] = _CacheData();
    }

    _cache[key]!.claims[page] = claims;
    _cache[key]!.totalPages = totalPages;
    _cache[key]!.lastUpdated = DateTime.now();

    // Persist updated cache
    _persistState();
  }

  List<GetClaimResponse>? getCachedClaims({
    required int page,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final key = _generateCacheKey(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    final cacheData = _cache[key];
    if (cacheData == null) return null;

    // Check if cache is still valid (15 minutes)
    if (DateTime.now().difference(cacheData.lastUpdated) >
        const Duration(minutes: 15)) {
      _cache.remove(key);
      _persistState();
      return null;
    }

    return cacheData.claims[page];
  }

  void saveViewState({
    required double scrollPosition,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    required int currentPage,
    int? totalPages,
  }) {
    this.scrollPosition = scrollPosition;
    this.currentStatus = status;
    this.currentStartDate = startDate;
    this.currentEndDate = endDate;
    this.currentPage = currentPage;
    this.totalPages = totalPages;
    _persistState();
  }

  void clearClaimsCache() {
    _cache.clear();
    _persistState();
  }

  void clearAll() {
    _cache.clear();
    scrollPosition = null;
    currentStatus = null;
    currentStartDate = null;
    currentEndDate = null;
    currentPage = 1;
    totalPages = null;
    _persistState();
    _prefs!.remove(_filterStateKey);
    _prefs!.remove(_claimsDataKey);
  }

  void saveFilterState({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    currentStatus = status;
    currentStartDate = startDate;
    currentEndDate = endDate;
    currentPage = 1;
    _persistState();
  }

  Future<void> saveScrollPosition(double position) async {
    scrollPosition = position;
    final filterState = {
      'status': currentStatus,
      'startDate': currentStartDate?.toIso8601String(),
      'endDate': currentEndDate?.toIso8601String(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'scrollPosition': position,
    };
    await _prefs!.setString(_filterStateKey, json.encode(filterState));
  }
}

class _CacheData {
  final Map<int, List<GetClaimResponse>> claims = {};
  int? totalPages;
  DateTime lastUpdated = DateTime.now();
}
