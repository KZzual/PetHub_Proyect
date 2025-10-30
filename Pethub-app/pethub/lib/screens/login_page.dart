import 'package:flutter/material.dart';
// 1. IMPORTAMOS EL MAIN SHELL (el contenedor de la app)
import '../main_shell.dart'; 
import '../utils/app_colors.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // true = muestra Login, false = muestra Registrarse
  bool _isLoginView = true;

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
        _buildTextField(hint: 'Correo Electrónico', icon: Icons.email_outlined),
        const SizedBox(height: 16),
        _buildTextField(
          hint: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isPasswordObscure,
          onToggleVisibility: () {
            setState(() {
              _isPasswordObscure = !_isPasswordObscure;
            });
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
          onPressed: () {
            // 2. ¡AQUÍ ESTÁ LA CORRECCIÓN!
            // Navegamos al MainShell (el contenedor de la app)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainShell()),
            );
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
        _buildTextField(hint: 'Nombre de usuario', icon: Icons.person_outline),
        const SizedBox(height: 24),
        _buildTextField(hint: 'Nombre Completo', icon: Icons.person_outline),
        const SizedBox(height: 16),
        _buildTextField(hint: 'Número de teléfono móvil', icon: Icons.phone_outlined),
        const SizedBox(height: 16),
        _buildTextField(hint: 'Correo Electrónico', icon: Icons.email_outlined),
        const SizedBox(height: 16),
        _buildTextField(
          hint: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isPasswordObscure,
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
          onPressed: () {
            // Lógica de registro
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
  }) {
    return TextField(
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