/*import '../service_delete/payment_process_screen.dart';

class PremiumInvoicesService {
  final List<PremiumServiceInvoice> _premiumInvoices = [];

  List<PremiumServiceInvoice> get premiumInvoices => _premiumInvoices;

  void addPremiumInvoice(PremiumServiceInvoice invoice) {
    _premiumInvoices.insert(0, invoice);
  }

  double getTotalPremiumAmount() {
    return _premiumInvoices.fold(0.0, (sum, invoice) => sum + invoice.amount);
  }

  int getTotalInvoicesCount() {
    return _premiumInvoices.length;
  }

  List<PremiumServiceInvoice> getInvoicesByService(String serviceName) {
    return _premiumInvoices
        .where((invoice) => invoice.serviceName == serviceName)
        .toList();
  }
}*/