import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _sending = false;
  bool _checking = false;

  Future<void> _resendEmail() async {
    setState(() => _sending = true);
    try {
      await AuthService.instance.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo de verificación enviado ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _checking = true);
    final ok = await AuthService.instance.isEmailVerified();
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true); //vuelve al login y continua al MainShell
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aún no verificas el correo')),
      );
    }
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar correo'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Te enviamos un correo a:',
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 6),
            Text(
              email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Revisa tu bandeja (o spam) y toca en el enlace de verificación.\n\n'
              'Cuando lo hayas hecho, vuelve aquí y presiona "Ya verifiqué".',
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _sending ? null : _resendEmail,
                    child: _sending
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Reenviar correo'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checking ? null : _checkVerified,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _checking
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Ya verifiqué'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
