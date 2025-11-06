# Hướng dẫn tích hợp Manual Seal Check vào Navigation Screen

## 📋 Các bước cần thực hiện trong navigation_screen.dart

### 1. Thêm method _fetchPendingSealReplacements()

Thêm method này vào class `_NavigationScreenState` (sau method `initState`):

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

### 2. Gọi _fetchPendingSealReplacements() trong initState()

Trong method `initState()`, sau khi `_loadOrderDetails()` hoàn thành, thêm:

```dart
// Load order details to ensure we have latest vehicle assignment info
debugPrint('   - Loading order details...');
_loadOrderDetails().then((_) {
  // After loading, check if we need to auto-resume (in case segments weren't loaded before)
  if (_viewModel.routeSegments.isNotEmpty && _viewModel.isSimulating && !_isSimulating) {
    debugPrint('   - Route segments loaded after init, checking resume');
    _checkAndResumeAfterAction();
  }
  
  // 🆕 THÊM DÒNG NÀY
  // Fetch pending seal replacements sau khi có order details
  _fetchPendingSealReplacements();
});
```

### 3. Thêm Banner vào body của Scaffold

Trong method `build()`, tìm `body: Column(children: [`, sau route info panel, thêm banner:

```dart
body: Column(
  children: [
    // Route info panel (existing code)
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primary.withOpacity(0.1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đoạn đường: ${_viewModel.getCurrentSegmentName()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tốc độ: ${_viewModel.currentSpeed.toStringAsFixed(1)} km/h',
                ),
              ],
            ),
          ),
          if (!widget.isSimulationMode)
            ElevatedButton(
              onPressed: () {
                // Navigate to simulation mode
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.navigation,
                  arguments: {
                    'orderId': widget.orderId,
                    'isSimulationMode': true,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              child: const Text('Mô phỏng'),
            ),
        ],
      ),
    ),

    // 🆕 THÊM BANNER NÀY - Pending Seal Replacement Banner
    if (_pendingSealReplacements.isNotEmpty)
      PendingSealReplacementBanner(
        issue: _pendingSealReplacements.first,
        onTap: () => _showConfirmSealSheet(_pendingSealReplacements.first),
      ),

    // Loading indicator cho pending seals
    if (_isLoadingPendingSeals)
      Container(
        padding: const EdgeInsets.all(8),
        color: AppColors.primary.withOpacity(0.05),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Đang kiểm tra seal...'),
          ],
        ),
      ),

    // Expanded map (existing code)
    Expanded(
      child: Stack(
        children: [
          // Map widget
          VietMapFlutter(
            onMapCreated: _onMapCreated,
            styleString: _mapStyle,
            initialCameraPosition: CameraPosition(
              target: _initialCenter,
              zoom: 15.0,
            ),
            onStyleLoadedCallback: _onStyleLoaded,
          ),
          // ... existing map overlays
        ],
      ),
    ),
  ],
),
```

### 4. Thêm refresh khi resume

Override `didChangeAppLifecycleState` để refresh khi user quay lại màn hình:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  super.didChangeAppLifecycleState(state);
  
  if (state == AppLifecycleState.resumed && mounted) {
    debugPrint('🔄 NavigationScreen resumed - refreshing pending seals');
    _fetchPendingSealReplacements();
  }
}
```

### 5. Thêm refresh khi order details load

Trong method `_loadOrderDetails()`, sau khi load thành công, thêm:

```dart
// Sau khi load order details thành công
if (_viewModel.order != null) {
  debugPrint('✅ Order details loaded, fetching pending seals...');
  _fetchPendingSealReplacements();
}
```

## 🎯 Flow hoạt động hoàn chỉnh:

### **Real-time Notification (Cách 1)**
1. Staff gán seal → Backend gửi WebSocket notification
2. Driver thấy dialog → Click "Xử lý ngay" → Về orders screen
3. Driver vào order đang giao → Về navigation screen
4. Banner hiển thị pending seal → Driver xử lý → Về orders

### **Manual Check (Cách 2)**
1. Driver vào navigation screen → `_fetchPendingSealReplacements()` được gọi
2. Nếu có pending seal → Banner màu cam hiển thị
3. Driver tap banner → Bottom sheet mở → Chụp ảnh → Confirm
4. Success → Về orders screen để tiếp tục chuyến

## 📱 UI Components đã có:

✅ **PendingSealReplacementBanner** - Widget banner màu cam  
✅ **ConfirmSealReplacementSheet** - Bottom sheet chụp ảnh  
✅ **IssueRepository.getPendingSealReplacements()** - API call  
✅ **IssueRepository.confirmSealReplacement()** - API confirm  

## 📋 Test Steps:

1. **Hot restart app** để apply changes
2. **Login** và vào một order đang giao
3. **Staff gán seal** (tạo issue với status IN_PROGRESS)
4. **Driver vào navigation screen** → Nên thấy banner
5. **Tap banner** → Bottom sheet mở → Chụp ảnh → Confirm
6. **Success** → Về orders screen → Banner biến mất

## 🔍 Debug Logs:

Khi vào navigation screen, bạn sẽ thấy:
```
📤 Fetching pending seal replacements for VA: {vehicle-assignment-id}
✅ Got {count} pending seal replacement(s)
```

Nếu có lỗi:
```
❌ Error fetching pending seal replacements: {error}
```

## 🎨 UI Preview:

Banner sẽ hiển thị ngay trên bản đồ:
```
┌─────────────────────────────────────┐
│ 🚛 Dẫn đường                          │
│ ┌─────────────────────────────────┐ │
│ │ 📍 Đoạn đường: Route Segment 1   │ │
│ │ 🚗 Tốc độ: 45.2 km/h            │ │
│ │ [Mô phỏng]                       │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ ⚠️ CẦN XÁC NHẬN SEAL MỚI         │ │
│ │ Seal cũ: SEAL-001 → Seal mới: SEAL-002 │ │
│ │ [Xử lý ngay]                     │ │
│ └─────────────────────────────────┘ │
│                                     │
│        🗺️ BẢN ĐỒ DẪN ĐƯỜNG          │
│                                     │
└─────────────────────────────────────┘
```

Sau khi tích hợp, driver sẽ có 2 cách để xử lý seal replacement! 🚀
