# Hướng dẫn tích hợp Pending Seal Replacement vào Navigation Screen

## 1. Thêm vào initState() của NavigationScreen

Sau dòng `_loadOrderDetails().then((_) {`, thêm:

```dart
// Fetch pending seal replacements
_fetchPendingSealReplacements();
```

## 2. Thêm method _fetchPendingSealReplacements()

Thêm method này vào class _NavigationScreenState:

```dart
/// Fetch pending seal replacements for current vehicle assignment
Future<void> _fetchPendingSealReplacements() async {
  if (_viewModel.order == null || 
      _viewModel.order!.vehicleAssignment == null) {
    debugPrint('⚠️ Cannot fetch pending seals - no vehicle assignment');
    return;
  }

  setState(() {
    _isLoadingPendingSeals = true;
  });

  try {
    final issueRepository = getIt<IssueRepository>();
    final vehicleAssignmentId = _viewModel.order!.vehicleAssignment!.id;
    
    debugPrint('📤 Fetching pending seal replacements for VA: $vehicleAssignmentId');
    
    final pendingIssues = await issueRepository.getPendingSealReplacements(
      vehicleAssignmentId,
    );
    
    setState(() {
      _pendingSealReplacements = pendingIssues;
      _isLoadingPendingSeals = false;
    });
    
    debugPrint('✅ Got ${pendingIssues.length} pending seal replacement(s)');
  } catch (e) {
    debugPrint('❌ Error fetching pending seal replacements: $e');
    setState(() {
      _isLoadingPendingSeals = false;
    });
  }
}

/// Show confirm seal replacement bottom sheet
void _showConfirmSealSheet(Issue issue) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ConfirmSealReplacementSheet(
      issue: issue,
      onConfirm: (imageBase64) async {
        try {
          final issueRepository = getIt<IssueRepository>();
          await issueRepository.confirmSealReplacement(
            issueId: issue.id,
            newSealAttachedImage: imageBase64,
          );
          
          // Refresh pending list
          _fetchPendingSealReplacements();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Đã xác nhận gắn seal mới thành công'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: $e')),
            );
          }
          rethrow;
        }
      },
    ),
  );
}
```

## 3. Thêm Banner vào body của Scaffold

Trong method `build()`, tìm `body: Column(children: [`, sau đó thêm banner ngay sau route info panel:

```dart
body: Column(
  children: [
    // Route info panel (existing code)
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primary.withOpacity(0.1),
      // ... existing route info code
    ),
    
    // 🆕 THÊM BANNER NÀY
    if (_pendingSealReplacements.isNotEmpty)
      PendingSealReplacementBanner(
        issue: _pendingSealReplacements.first,
        onTap: () => _showConfirmSealSheet(_pendingSealReplacements.first),
      ),
    
    // Expanded map (existing code)
    Expanded(
      child: Stack(
        // ... existing map code
      ),
    ),
  ],
),
```

## 4. Register IssueRepository trong service_locator.dart (Nếu chưa có)

Kiểm tra xem đã có IssueRepository trong service locator chưa. Nếu chưa, thêm:

```dart
// Repositories
getIt.registerLazySingleton<IssueRepository>(
  () => IssueRepositoryImpl(getIt<ApiClient>()),
);
```

## 5. Thêm UseCase vào service_locator.dart (Optional - nếu muốn dùng UseCase pattern)

```dart
// Use cases
getIt.registerLazySingleton<ConfirmSealReplacementUseCase>(
  () => ConfirmSealReplacementUseCase(getIt<IssueRepository>()),
);
```

## 6. Test Backend API

Trước khi test mobile app, hãy test backend API bằng Postman:

```
GET http://localhost:8080/api/issues/vehicle-assignment/{vehicleAssignmentId}/pending-seal-replacements
```

Response mong đợi:
```json
{
  "status": "OK",
  "message": "Success",
  "data": [
    {
      "id": "issue-id",
      "status": "IN_PROGRESS",
      "issueCategory": "SEAL_REPLACEMENT",
      "oldSeal": {
        "id": "old-seal-id",
        "sealCode": "SEAL-001"
      },
      "newSeal": {
        "id": "new-seal-id",
        "sealCode": "SEAL-002"
      },
      "newSealConfirmedAt": null
    }
  ]
}
```

## 7. Flow hoạt động

1. **Driver vào màn hình navigation** → `_fetchPendingSealReplacements()` được gọi
2. **Nếu có seal replacement pending** → Banner màu cam hiển thị
3. **Driver tap vào banner** → Bottom sheet mở ra
4. **Driver chụp ảnh seal mới** → Upload và confirm
5. **API confirm thành công** → Banner biến mất, refresh list

## 8. Các trường hợp đặc biệt

- **Không có vehicle assignment**: Banner không hiển thị
- **Không có pending issues**: Banner không hiển thị  
- **Nhiều issues pending**: Chỉ hiển thị issue đầu tiên
- **Network error**: Log error, không crash app
- **Driver tắt notification**: Vẫn thấy banner trong navigation screen

## 9. Debugging

Nếu banner không hiển thị, check console logs:

```
📤 Fetching pending seal replacements for VA: {id}
✅ Got {count} pending seal replacement(s)
```

Nếu có lỗi:
```
❌ Error fetching pending seal replacements: {error}
```

## 10. Restart Backend và Mobile App

1. Restart backend để apply API changes
2. Hot restart mobile app để apply code changes
3. Login và navigate đến màn hình dẫn đường
4. Banner sẽ hiển thị nếu có pending seal replacement
