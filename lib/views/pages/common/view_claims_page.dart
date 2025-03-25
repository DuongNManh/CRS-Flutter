import 'package:flutter/material.dart';
import 'package:learning_android_1/models/claim_interface.dart';
import 'package:learning_android_1/services/claim_service.dart';
import 'package:learning_android_1/data/notifiers.dart';
import 'package:learning_android_1/data/status_color.dart';
import 'package:intl/intl.dart';
import 'package:learning_android_1/views/widgets/date_range_picker_widget.dart';
import 'package:learning_android_1/views/widgets/status_dropdown_widget.dart';
import 'package:learning_android_1/services/cache/claims_cache_service.dart';
import 'package:learning_android_1/views/pages/common/view_claim_detail_page.dart';
import 'package:learning_android_1/views/widgets/auth_guard.dart';

class ViewClaimsPage extends StatefulWidget {
  const ViewClaimsPage({super.key});

  @override
  State<ViewClaimsPage> createState() => _ViewClaimsPageState();
}

class _ViewClaimsPageState extends State<ViewClaimsPage> {
  final ClaimService _claimService = ClaimService();
  final ClaimsCacheService _cacheService = ClaimsCacheService();
  final ScrollController _scrollController = ScrollController();
  List<GetClaimResponse> claims = [];
  int currentPage = 1;
  int pageSize = 15;
  String? status;
  String? viewMode = "ClaimerMode";
  bool isLoading = false;
  bool hasMoreData = true;
  int totalPages = 1;
  bool isDropdownOpen = false;
  DateTime? startDate;
  DateTime? endDate;
  bool _isRestoringScroll = false;

  @override
  void initState() {
    super.initState();
    _initCache();
  }

  Future<void> _initCache() async {
    await _cacheService.init();
    _scrollController.addListener(_scrollListener);
    _restoreState();
  }

  void _scrollListener() {
    if (_isRestoringScroll) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMoreData) {
        currentPage++;
        _loadClaims();
      }
    }

    _cacheService.saveScrollPosition(_scrollController.position.pixels);
  }

  void _restoreState() {
    setState(() {
      status = _cacheService.currentStatus;
      startDate = _cacheService.currentStartDate;
      endDate = _cacheService.currentEndDate;
      currentPage = _cacheService.currentPage;
      totalPages = _cacheService.totalPages ?? 1;

      final cachedClaims = _cacheService.getCachedClaims(
        page: currentPage,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );

      if (cachedClaims != null) {
        claims = cachedClaims;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _restoreScrollPosition();
        });
      } else {
        _loadClaims();
      }
    });
  }

  Future<void> _restoreScrollPosition() async {
    if (_cacheService.scrollPosition != null && _scrollController.hasClients) {
      _isRestoringScroll = true;
      try {
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted && _scrollController.hasClients) {
          await _scrollController.animateTo(
            _cacheService.scrollPosition!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } finally {
        _isRestoringScroll = false;
      }
    }
  }

  @override
  void dispose() {
    if (_scrollController.hasClients) {
      _cacheService.saveScrollPosition(_scrollController.position.pixels);
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadClaims() async {
    if (isLoading) return;

    final cachedClaims = _cacheService.getCachedClaims(
      page: currentPage,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    if (cachedClaims != null) {
      setState(() {
        if (currentPage == 1) {
          claims = cachedClaims;
          if (_cacheService.scrollPosition != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _restoreScrollPosition();
            });
          }
        } else {
          claims.addAll(cachedClaims);
        }
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _claimService.getClaimPaging(
        pageNum: currentPage,
        pageSize: pageSize,
        status: status,
        viewMode: viewMode,
        startDate:
            startDate != null
                ? DateFormat('yyyy-MM-dd').format(startDate!)
                : null,
        endDate:
            endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      );

      if (response.isSuccess && response.data != null) {
        final newClaims = response.data?.items ?? [];
        final newTotalPages = response.data!.meta.totalPages;

        _cacheService.cacheClaimsData(
          claims: newClaims,
          page: currentPage,
          totalPages: newTotalPages,
          status: status,
          startDate: startDate,
          endDate: endDate,
        );

        setState(() {
          totalPages = newTotalPages;
          if (currentPage == 1) {
            claims = newClaims;
          } else {
            claims.addAll(newClaims);
          }
          hasMoreData = currentPage < totalPages;
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('Error fetching claims: ${response.message}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load claims: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onFilterChanged(String? newStatus) {
    _cacheService.saveScrollPosition(0);
    setState(() {
      status = newStatus;
      currentPage = 1;
      claims.clear();
      _cacheService.clearClaimsCache();
      _cacheService.saveFilterState(
        status: newStatus,
        startDate: startDate,
        endDate: endDate,
      );
    });
    _loadClaims();
  }

  Future<void> _showDateRangePicker() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerWidget(
          startDate: startDate,
          endDate: endDate,
          onDateRangeSelected: (DateTimeRange selectedRange) {
            setState(() {
              startDate = selectedRange.start;
              endDate = selectedRange.end;
              currentPage = 1;
              claims.clear();
              _cacheService.clearClaimsCache();
              _cacheService.saveFilterState(
                status: status,
                startDate: selectedRange.start,
                endDate: selectedRange.end,
              );
            });
            _loadClaims();
          },
        );
      },
    );
  }

  void _clearFilters() {
    _cacheService.clearAll();
    setState(() {
      status = null;
      startDate = null;
      endDate = null;
      currentPage = 1;
      claims.clear();
      _scrollController.jumpTo(0);
    });
    _loadClaims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Claims'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StatusDropdownWidget(
              selectedStatus: status,
              onStatusChanged: _onFilterChanged,
            ),
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.calendar_today),
                if (startDate != null && endDate != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Select Date Range',
            onPressed: _showDateRangePicker,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear Filters',
            onPressed:
                (status == null && startDate == null && endDate == null)
                    ? null
                    : _clearFilters,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return claims.isEmpty
                    ? const Center(child: Text('No claims found'))
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount: claims.length + (isLoading ? 1 : 0),
                      padding: const EdgeInsets.only(bottom: 50),
                      itemBuilder: (context, index) {
                        if (index == claims.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final claim = claims[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AuthGuard(
                                      child: ViewClaimDetailPage(
                                        claimId: claim.id,
                                      ),
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              gradient:
                                  isDarkMode
                                      ? LinearGradient(
                                        colors: [
                                          Color(0xFF1a237e),
                                          Color(0xFF1cb5e0),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                      : LinearGradient(
                                        colors: [
                                          Color(0xFFb92b27),
                                          Color(0xFF1565C0),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15.0,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: StatusColor.getStatusColor(
                                            claim.status,
                                          ).withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 6.0,
                                        ),
                                        child: Text(
                                          claim.status,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    claim.name,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.business,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          claim.project?.name ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'WORKING HOURS',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          Text(
                                            '${claim.totalWorkingHours}h',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'AMOUNT',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          Text(
                                            '${claim.amount} VND',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Created: ${claim.createAt}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
