enum BrdrSideType { bottom, top, right, left }

enum SupplierTabType { requested, accepted, readyToDelivery, delivered, rejected, confirmed }

enum UserRole { customer, supplier, admin }

enum OtpFlowType { signup, forgotPassword }

enum FuelType { fuel, diesel }

enum CreateOrderState { loading, success, failure }

enum CustomerOrderCategory {
  pending,
  canceled,
  rejected,
  accepted,
  onTheWay,
  completed,
  confirmed,
  none,
}

enum SupplierOrderAction { accept, onTheWay, complete, delete, confirm, reject, cancel }

enum SessionStatus { upcoming, ongoing }
