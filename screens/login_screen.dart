import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../state/app_state.dart';
import 'admin_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SeniorShell()));
  }

  Future<void> _sendOtp(S s) async {
    final otpController = TextEditingController(text: '1234');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.sendOtp),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(labelText: 'OTP'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Verify')),
        ],
      ),
    );
    if (confirmed == true && mounted) _goToDashboard();
  }

  void _scanQr(S s) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.scanQr),
        content: const SizedBox(
          height: 160,
          width: 160,
          child: Center(child: Icon(Icons.qr_code_scanner_rounded, size: 96)),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _goToDashboard();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final s = app.s;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.loginTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.loginInstruction, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text(s.idFieldLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(controller: _idController, decoration: const InputDecoration(hintText: 'TAB-SC-YYYY-NNNN')),
              const SizedBox(height: 18),
              Text(s.mobileFieldLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '09XX XXX XXXX'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _scanQr(s),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: Text(s.scanQr),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: () => _sendOtp(s), child: Text(s.sendOtp)),
              ),
              const SizedBox(height: 28),
              Divider(color: scheme.outlineVariant),
              const SizedBox(height: 16),
              Text('Demo shortcuts', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.outline)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: _goToDashboard, child: Text(s.demoLoginMaria)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    app.setPortal(Portal.admin);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
                  },
                  child: Text(s.admin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
