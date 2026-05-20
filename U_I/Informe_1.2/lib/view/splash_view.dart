import 'package:flutter/material.dart';

// ─── ÁTOMO: Logo Widget ───────────────────────────────────────────────────────
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.calculate_rounded, size: 90, color: Colors.white),
    );
  }
}

// ─── ÁTOMO: Texto de título ───────────────────────────────────────────────────
class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Laboratorio 2',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Atomic Design · UI Components',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        SizedBox(height: 4),
        Text(
          'Grupo Móviles',
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
      ],
    );
  }
}

// ─── MOLÉCULA: Indicador de carga ────────────────────────────────────────────
class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        const SizedBox(height: 12),
        Text(
          'Cargando...',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
        ),
      ],
    );
  }
}

// ─── ORGANISMO: Splash Card ───────────────────────────────────────────────────
class _SplashCard extends StatelessWidget {
  const _SplashCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _SplashLogo(),
        SizedBox(height: 30),
        _SplashTitle(),
        SizedBox(height: 50),
        _SplashLoader(),
      ],
    );
  }
}

// ─── PÁGINA: SplashView ───────────────────────────────────────────────────────
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    _animCtrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: const _SplashCard(),
            ),
          ),
        ),
      ),
    );
  }
}
