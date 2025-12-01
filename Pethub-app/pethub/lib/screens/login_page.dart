import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pethub/main_shell.dart';
import '../utils/app_colors.dart';
import '../auth_service.dart';
import 'verify_email_page.dart';
import 'success_account_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginView = true;

  // LOGIN
  bool _loadingLogin = false;
  final TextEditingController _loginEmailCtrl = TextEditingController();
  final TextEditingController _loginPassCtrl = TextEditingController();

  // REGISTRO
  final TextEditingController _regNameCtrl = TextEditingController();
  final TextEditingController _regPhoneCtrl = TextEditingController();
  final TextEditingController _regEmailCtrl = TextEditingController();
  final TextEditingController _regPassCtrl = TextEditingController();
  final TextEditingController _regPass2Ctrl = TextEditingController();
  bool _loadingRegister = false;
  bool _rememberMe = true;

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
    void initState() {
      super.initState();
      }

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regPhoneCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regPass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo
        Image.asset(
          'assets/images/background.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.accent,
              alignment: Alignment.center,
              child: const Text('Añade assets/pet_background.jpg'),
            );
          },
        ),

        // Contenido principal
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleButtons(),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isLoginView
                              ? _buildLoginForm()
                              : _buildRegisterForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Botones Iniciar / Registrar
  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLoginView = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: _isLoginView
                      ? AppColors.primary.withAlpha(50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'INICIAR SESIÓN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        _isLoginView ? AppColors.primary : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLoginView = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: !_isLoginView
                      ? AppColors.primary.withAlpha(50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'REGISTRARSE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        !_isLoginView ? AppColors.primary : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- LOGIN ----------
  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
        Text(
          'Bienvenido a PetHub',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa tus credenciales para acceder',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          hint: 'Correo Electrónico',
          icon: Icons.email_outlined,
          controller: _loginEmailCtrl,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hint: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isPasswordObscure,
          controller: _loginPassCtrl,
          onToggleVisibility: () {
            setState(() => _isPasswordObscure = !_isPasswordObscure);
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (val) =>
                      setState(() => _rememberMe = val ?? true),
                ),
                const Text('Recuérdame'),
              ],
            ),
            Flexible(
              child: TextButton(
                onPressed: _showPasswordResetDialog,
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
          ),
          onPressed: _loadingLogin ? null : _handleLogin,
          child: const Text('INICIAR SESIÓN'),
        ),
      ],
    );
  }

  // ---------- REGISTRO ----------
  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register'),
      children: [
        Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Únete a nuestra comunidad de adopción',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),

        _buildTextField(
          hint: 'Nombre Completo',
          icon: Icons.person_outline,
          controller: _regNameCtrl,
        ),
        const SizedBox(height: 16),

        // campo Teléfono chileno +569
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                'Número de teléfono',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _regPhoneCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                style: const TextStyle(color: AppColors.textDark),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textDark),
                  prefixText: '+56',
                  hintText: 'Número de teléfono',
                  hintStyle: TextStyle(color: Color(0xFF777777)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildTextField(
          hint: 'Correo Electrónico',
          icon: Icons.email_outlined,
          controller: _regEmailCtrl,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          hint: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isPasswordObscure,
          controller: _regPassCtrl,
          onToggleVisibility: () =>
              setState(() => _isPasswordObscure = !_isPasswordObscure),
        ),
        const SizedBox(height: 16),

        _buildTextField(
          hint: 'Confirmar contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isConfirmPasswordObscure,
          controller: _regPass2Ctrl,
          onToggleVisibility: () => setState(
              () => _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
        ),
        const SizedBox(height: 24),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: _loadingRegister ? null : _handleRegister,
          child: const Text('CREAR CUENTA'),
        ),
      ],
    );
  }

  // ---------- Funciones ----------
  Future<void> _handleLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final pass = _loginPassCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
        content: Text('Ingresa correo y contraseña')),
      );
      return;
    }

    setState(() => _loadingLogin = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);

      await AuthService.instance.signIn(email: email, password: pass);
      final verified = await AuthService.instance.isEmailVerified();

      if (!mounted) return;
      if (!verified) {
        final ok = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
        );
        if (ok == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SuccessAccountPage()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
          content: Text('Cuenta no existe. Regístrese o revise sus datos.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingLogin = false);
    }
  }

  Future<void> _handleRegister() async {
    final name = _regNameCtrl.text.trim();
    final phone = _regPhoneCtrl.text.trim();
    final email = _regEmailCtrl.text.trim();
    final pass1 = _regPassCtrl.text.trim();
    final pass2 = _regPass2Ctrl.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        pass1.isEmpty ||
        pass2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (phone.length != 9 || int.tryParse(phone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
          content: Text('Número inválido'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (pass1.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ),
            content: Text('La contraseña debe tener al menos 6 caracteres')),
      );
      return;
    }

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
            ), 
            content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _loadingRegister = true);
    try {
      await AuthService.instance
          .signUp(email: email, password: pass1, displayName: name);

      await UserService.createUserProfile(
        name: name,
        email: email,
        phone: '+56$phone',
      );

      if (!mounted) return;
      final verified = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
      );

      if (verified == true && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessAccountPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loadingRegister = false);
    }
  }

  void _showPasswordResetDialog() {
    final TextEditingController resetEmailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recuperar contraseña'),
          content: TextField(
            controller: resetEmailCtrl,
            decoration: const InputDecoration(
              hintText: 'Ingresa tu correo',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = resetEmailCtrl.text.trim();
                if (email.isEmpty) return;
                try {
                  await AuthService.instance.sendPasswordReset(email: email);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), 
                          ),
                        content: Text(
                            'Se ha enviado un correo para restablecer tu contraseña'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  // ---------- TextField reutilizable ----------
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: const TextStyle(color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF777777)),
          prefixIcon: Icon(icon, color: AppColors.textDark),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textDark,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
