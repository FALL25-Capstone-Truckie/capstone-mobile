import 'package:flutter/material.dart';
import '../../domain/entities/order_with_details.dart';
import '../features/auth/viewmodels/auth_viewmodel.dart';

/// Utility class để kiểm tra driver role và permissions
class DriverRoleChecker {
  /// Kiểm tra xem user hiện tại có phải là primary driver của order không
  /// Sử dụng phone number làm unique identifier (ID có thể khác giữa auth và order response)
  static bool isPrimaryDriver(OrderWithDetails order, AuthViewModel authViewModel) {
    if (order.orderDetails.isEmpty || order.vehicleAssignments.isEmpty) {
      return false;
    }
    
    final vehicleAssignmentId = order.orderDetails.first.vehicleAssignmentId;
    if (vehicleAssignmentId == null) {
      return false;
    }
    
    final vehicleAssignment = order.vehicleAssignments
        .cast<dynamic>()
        .firstWhere(
          (va) => va?.id == vehicleAssignmentId,
          orElse: () => null,
        );
    if (vehicleAssignment == null) {
      return false;
    }
    
    final primaryDriver = vehicleAssignment.primaryDriver;
    if (primaryDriver == null) {
      return false;
    }
    
    // Get current user phone number (most reliable identifier)
    final currentUserPhone = authViewModel.driver?.userResponse.phoneNumber;
    final primaryDriverPhone = primaryDriver.phoneNumber;
    
    // debugPrint('🔍 DriverRoleChecker.isPrimaryDriver:');
    // debugPrint('   📱 CURRENT USER (from auth):');
    // debugPrint('      - Phone: "$currentUserPhone"');
    // debugPrint('      - Name: "${authViewModel.driver?.userResponse.fullName}"');
    // debugPrint('      - Username: "${authViewModel.driver?.userResponse.username}"');
    // debugPrint('   🚗 PRIMARY DRIVER (from order):');
    // debugPrint('      - Phone: "$primaryDriverPhone"');
    // debugPrint('      - Name: "${primaryDriver.fullName}"');
    // debugPrint('   🚗 SECONDARY DRIVER (from order):');
    // debugPrint('      - Phone: "${vehicleAssignment.secondaryDriver?.phoneNumber}"');
    // debugPrint('      - Name: "${vehicleAssignment.secondaryDriver?.fullName}"');
    
    // Primary method: Compare by phone number (unique and reliable)
    if (currentUserPhone != null && 
        currentUserPhone.isNotEmpty &&
        primaryDriverPhone.isNotEmpty &&
        currentUserPhone.trim() == primaryDriverPhone.trim()) {
      // debugPrint('   ✅ MATCHED: Current user IS PRIMARY DRIVER');
      return true;
    }
    
    // Check if current user is secondary driver
    final secondaryDriverPhone = vehicleAssignment.secondaryDriver?.phoneNumber;
    if (currentUserPhone != null && 
        currentUserPhone.isNotEmpty &&
        secondaryDriverPhone != null &&
        secondaryDriverPhone.isNotEmpty &&
        currentUserPhone.trim() == secondaryDriverPhone.trim()) {
      debugPrint('   ⚠️ Current user IS SECONDARY DRIVER (not primary)');
      return false;
    }

    debugPrint('   ❌ NOT MATCHED: Current user is NEITHER primary nor secondary driver');
    return false;
  }
  
  /// Kiểm tra xem user hiện tại có phải là secondary driver của order không
  /// Sử dụng phone number làm unique identifier
  static bool isSecondaryDriver(OrderWithDetails order, AuthViewModel authViewModel) {
    if (order.orderDetails.isEmpty || order.vehicleAssignments.isEmpty) return false;
    
    final vehicleAssignmentId = order.orderDetails.first.vehicleAssignmentId;
    if (vehicleAssignmentId == null) return false;
    
    final vehicleAssignment = order.vehicleAssignments
        .cast<dynamic>()
        .firstWhere(
          (va) => va?.id == vehicleAssignmentId,
          orElse: () => null,
        );
    if (vehicleAssignment == null) return false;
    
    final secondaryDriver = vehicleAssignment.secondaryDriver;
    if (secondaryDriver == null) return false;
    
    // Get current user phone number (most reliable identifier)
    final currentUserPhone = authViewModel.driver?.userResponse.phoneNumber;
    final secondaryDriverPhone = secondaryDriver.phoneNumber;
    
    // Compare by phone number (unique and reliable)
    if (currentUserPhone != null && 
        currentUserPhone.isNotEmpty &&
        secondaryDriverPhone.isNotEmpty &&
        currentUserPhone.trim() == secondaryDriverPhone.trim()) {
      return true;
    }
    
    return false;
  }
  
  /// Kiểm tra xem user hiện tại có được phép thực hiện actions trên order không
  /// Chỉ primary driver mới được phép thực hiện actions
  static bool canPerformActions(OrderWithDetails order, AuthViewModel authViewModel) {
    return isPrimaryDriver(order, authViewModel);
  }
  
  /// Lấy thông tin role của user hiện tại
  static String getUserRole(OrderWithDetails order, AuthViewModel authViewModel) {
    if (isPrimaryDriver(order, authViewModel)) {
      return 'primary_driver';
    } else if (isSecondaryDriver(order, authViewModel)) {
      return 'secondary_driver';
    } else {
      return 'unknown';
    }
  }
  
  /// Lấy thông tin role hiển thị cho user
  static String getUserRoleDisplayName(OrderWithDetails order, AuthViewModel authViewModel) {
    if (isPrimaryDriver(order, authViewModel)) {
      return 'Tài xế chính';
    } else if (isSecondaryDriver(order, authViewModel)) {
      return 'Tài xế phụ';
    } else {
      return 'Không xác định';
    }
  }
  
  /// Lấy thông báo khi secondary driver cố gắng thực hiện action
  static String getSecondaryDriverActionMessage() {
    return 'Chỉ tài xế chính mới có thể thực hiện hành động này. Bạn đang đăng nhập với tài khoản tài xế phụ.';
  }
  
  /// Hiển thị thông báo khi secondary driver cố gắng thực hiện action
  static void showSecondaryDriverActionDialog(BuildContext context, OrderWithDetails order, AuthViewModel authViewModel) {
    if (!canPerformActions(order, authViewModel)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text('Quyền hạn bị giới hạn'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getSecondaryDriverActionMessage()),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Vai trò hiện tại: ${getUserRoleDisplayName(order, authViewModel)}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đã hiểu'),
              ),
            ],
          );
        },
      );
    }
  }
}
