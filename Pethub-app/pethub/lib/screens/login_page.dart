import 'package:flutter/material.dart';
// 1. IMPORTAMOS EL MAIN SHELL (el contenedor de la app)
import '../main_shell.dart'; 
import '../utils/app_colors.dart'; 
// Auth
import '../auth_service.dart';
import 'verify_email_page.dart';
import 'success_account_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  // true = muestra Login, false = muestra Registrarse
  bool _isLoginView = true;
  //LOGIN
  bool _loadingLogin = false;
  final TextEditingController _loginEmailCtrl = TextEditingController();
  final TextEditingController _loginPassCtrl  = TextEditingController();
  //REGISTRO
  final TextEditingController _regNameCtrl    = TextEditingController();
  final TextEditingController _regPhoneCtrl   = TextEditingController();
  final TextEditingController _regEmailCtrl   = TextEditingController();
  final TextEditingController _regPassCtrl    = TextEditingController();
  final TextEditingController _regPass2Ctrl   = TextEditingController();
  bool _loadingRegister = false;

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


  // Controladores para la visibilidad de la contraseña
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    // Usamos un Stack para poner la imagen de fondo
    return Stack(
      children: [
        // 1. Imagen de Fondo
        Image.asset(
          'assets/pet_background.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          // Fallback por si la imagen no carga
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.accent,
              alignment: Alignment.center,
              child: const Text('Añade assets/pet_background.jpg'),
            );
          },
        ),

        // 2. Contenido de la página (transparente)
        Scaffold(
          backgroundColor: Colors.transparent, // Fondo transparente
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  // 3. La tarjeta
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25), // (0.1 opacidad)
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Que se ajuste al contenido
                      children: [
                        // 4. Botones de Pestaña (Toggle)
                        _buildToggleButtons(),
                        const SizedBox(height: 24),

                        // 5. Formulario (cambia dinámicamente)
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

  // --- Widgets de Ayuda ---

  // Botones "INICIAR SESIÓN" y "REGISTRARSE"
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
              onTap: () {
                setState(() {
                  _isLoginView = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: _isLoginView ? AppColors.primary.withAlpha(50) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'INICIAR SESIÓN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isLoginView ? AppColors.primary : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLoginView = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: !_isLoginView ? AppColors.primary.withAlpha(50) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'REGISTRARSE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !_isLoginView ? AppColors.primary : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Formulario de INICIAR SESIÓN
  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
         Text(
          'Bienvenido de vuelta',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: AppColors.textDark
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa tus credenciales para acceder',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
        hint: 'Correo Electrónico', icon: Icons.email_outlined, controller: _loginEmailCtrl,),
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
                Checkbox(value: false, onChanged: (val) {}),
                const Text('Recuérdame'),
              ],
            ),
            Flexible(
              child: TextButton(
                onPressed: () {},
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
          ),
          onPressed: _loadingLogin ? null : () async {
            final email = _loginEmailCtrl.text.trim();
            final pass  = _loginPassCtrl.text.trim();

            if (email.isEmpty || pass.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ingresa correo y contraseña')),
              );
              return;
            }
            setState(() => _loadingLogin = true);
            try {
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
                    context, MaterialPageRoute(builder: (_) => const MainShell()),
                  );
                }
              } else {
                Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MainShell()),
                );
              }

            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            } finally {
              if (mounted) setState(() => _loadingLogin = false);
            }
        },
          child: const Text('INICIAR SESIÓN'),
        ),
      ],
    );
  }

  // Formulario de CREAR CUENTA
  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register'),
      children: [
         Text(
          'Crear cuenta',
           style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: AppColors.textDark
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Únete a nuestra comunidad de adopción',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
          _buildTextField(hint: 'Nombre Completo', icon: Icons.person_outline, controller: _regNameCtrl),
        const SizedBox(height: 16),
          _buildTextField(hint: 'Número de teléfono móvil', icon: Icons.phone_outlined, controller: _regPhoneCtrl),
        const SizedBox(height: 16),
          _buildTextField(hint: 'Correo Electrónico', icon: Icons.email_outlined, controller: _regEmailCtrl),
        const SizedBox(height: 16),
          _buildTextField(
          hint: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isPasswordObscure,
          controller: _regPassCtrl,
          onToggleVisibility: () {
            setState(() {
              _isPasswordObscure = !_isPasswordObscure;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hint: 'Confirmar contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isConfirmPasswordObscure,
          controller: _regPass2Ctrl,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
            });
          },
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
         onPressed: _loadingRegister ? null : () async {
          final name  = _regNameCtrl.text.trim();
          final phone = _regPhoneCtrl.text.trim();
          final email = _regEmailCtrl.text.trim();
          final pass1 = _regPassCtrl.text.trim();
          final pass2 = _regPass2Ctrl.text.trim();

          if (name.isEmpty || phone.isEmpty || email.isEmpty || pass1.isEmpty || pass2.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Completa todos los campos')),
            );
            return;
          }

          if (pass1.length < 6) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
            );
            return;
          }

          if (pass1 != pass2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Las contraseñas no coinciden')),
            );
            return;
          }

          setState(() => _loadingRegister = true);

          try {
            // 🔹 Crea usuario en Firebase
            await AuthService.instance.signUp(
              email: email,
              password: pass1,
              displayName: name,
            );

            // 🔹 Muestra la pantalla de verificación
            if (!mounted) return;
            final verified = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
            );

            // 🔹 Si verificó, entra directo a MainShell
            if (verified == true && mounted) {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SuccessAccountPage()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          } finally {
            if (mounted) setState(() => _loadingRegister = false);
          }
        },

          child: const Text('CREAR CUENTA'),
        ),
      ],
    );
  }

  // Widget genérico para los campos de texto
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
    TextEditingController? controller
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: AppColors.accent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

