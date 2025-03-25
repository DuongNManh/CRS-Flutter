import 'package:flutter/material.dart';
import 'package:learning_android_1/data/status_color.dart';
import 'package:learning_android_1/models/claim_interface.dart';
import 'package:learning_android_1/services/claim_service.dart';

class ViewClaimDetailPage extends StatefulWidget {
  const ViewClaimDetailPage({super.key, required this.claimId});
  final String claimId;

  @override
  State<ViewClaimDetailPage> createState() => _ViewClaimDetailPageState();
}

class _ViewClaimDetailPageState extends State<ViewClaimDetailPage> {
  final ClaimService _claimService = ClaimService();
  ClaimDetailResponse? claimDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClaimDetail(widget.claimId);
  }

  Future<void> _fetchClaimDetail(String claimId) async {
    try {
      final response = await _claimService.getClaimById(id: claimId);

      if (response.isSuccess && response.data != null && mounted) {
        setState(() {
          claimDetail = response.data;
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('Error fetching claim: ${response.message}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load claim: ${e.toString()}');
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(claimDetail?.name ?? 'Claim Detail'),
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : claimDetail == null
              ? const Center(child: Text('No claim details found'))
              : Column(
                children: [
                  _buildStatusHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildClaimInfoCard(),
                          const SizedBox(height: 16),
                          if (claimDetail?.project != null) ...[
                            _buildProjectCard(),
                            const SizedBox(height: 16),
                          ],
                          if (claimDetail!.claimApprovers.isNotEmpty) ...[
                            _buildApproversCard(),
                            const SizedBox(height: 16),
                          ],
                          _buildChangeHistoryCard(),
                          const SizedBox(
                            height: 80,
                          ), // Space for bottom buttons
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildStatusHeader() {
    if (claimDetail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  '${claimDetail?.amount ?? 0} VND',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: StatusColor.getStatusColor(claimDetail?.status ?? ''),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              claimDetail?.status ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimInfoCard() {
    if (claimDetail == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Claim Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildInfoRow('Type', claimDetail?.claimType ?? 'N/A'),
            _buildInfoRow(
              'Working Hours',
              '${claimDetail?.totalWorkingHours ?? 0}h',
            ),
            _buildInfoRow('Start Date', claimDetail?.startDate ?? 'N/A'),
            _buildInfoRow('End Date', claimDetail?.endDate ?? 'N/A'),
            _buildInfoRow('Created', claimDetail?.createAt ?? 'N/A'),
            const SizedBox(height: 8),
            Text('Remark', style: Theme.of(context).textTheme.titleSmall),
            Text(
              claimDetail?.remark ?? 'No remark',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard() {
    if (claimDetail?.project == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business),
                const SizedBox(width: 8),
                Text(
                  'Project Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Name', claimDetail!.project!.name),
            if (claimDetail!.project!.projectManager != null)
              _buildInfoRow('Manager', claimDetail!.project!.projectManager!),
            if (claimDetail!.project!.description != null)
              _buildInfoRow('Description', claimDetail!.project!.description!),
          ],
        ),
      ),
    );
  }

  Widget _buildApproversCard() {
    if (claimDetail?.claimApprovers.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                Text(
                  'Approval Flow',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: claimDetail?.claimApprovers.length ?? 0,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final approver = claimDetail!.claimApprovers[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    approver.name.isNotEmpty ? approver.name[0] : '?',
                  ),
                ),
                title: Text(approver.name),
                subtitle: Text(approver.decisionAt),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: StatusColor.getStatusColor(
                      approver.approverStatus,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    approver.approverStatus,
                    style: TextStyle(
                      color: StatusColor.getStatusColor(
                        approver.approverStatus,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChangeHistoryCard() {
    if (claimDetail!.changeHistory.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.history),
                const SizedBox(width: 8),
                Text(
                  'Change History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: claimDetail!.changeHistory.length,
            itemBuilder: (context, index) {
              final change = claimDetail!.changeHistory[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            change.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            change.changedAt,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (claimDetail == null) return const SizedBox.shrink();

    List<Widget> actions = [];

    switch (claimDetail?.status) {
      case 'Draft':
        actions = [
          _buildActionButton('Submit', Colors.blue, () {}),
          _buildActionButton('Update', Colors.green, () {}),
          _buildActionButton('Cancel', Colors.red, () {}),
        ];
        break;
      case 'Pending':
        actions = [_buildActionButton('Cancel', Colors.red, () {})];
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions,
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
