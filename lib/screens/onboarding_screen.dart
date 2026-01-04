import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/haptic_typewriter_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _headingController = HapticTypewriterController();
  final _subtextController = HapticTypewriterController();

  // To avoid rapid re-triggering if user spams button
  bool _isAnimating = false;

  // Animation durations
  static const _headingSpeed = Duration(milliseconds: 80);
  static const _subtextSpeed = Duration(milliseconds: 60);

  void _handleButtonPress() {
    if (_isAnimating) return;

    // Reset and start animation
    setState(() => _isAnimating = true);

    // Animate Heading first
    _headingController.type("Haptic Typewriter Text Animation");
  }

  void _onHeadingComplete() {
    if (!mounted) return;
    // Start subtext animation immediately after heading completes
    _subtextController.type(
      "This a pretty sick and elegant text animation built in flutter",
    );
    // Determine when valid "animation" sequence ends for button re-enabling
    // We could add an onComplete to subtext too if we wanted to toggle _isAnimating exactly then
    // For now, let's just leave _isAnimating true or toggle it off after subtext is done?
    // Let's add onComplete to subtext as well to be precise.
  }

  void _onSubtextComplete() {
    if (mounted) {
      setState(() => _isAnimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Heading Area
            SizedBox(
              height: 100, // Fixed height to prevent layout jump?
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: HapticTypewriterText(
                    controller: _headingController,
                    style: GoogleFonts.nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      color: Colors.black,
                    ),
                    speed: _headingSpeed,
                    onComplete: _onHeadingComplete,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Subtext Area
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: HapticTypewriterText(
                    controller: _subtextController,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                    speed: _subtextSpeed,
                    onComplete: _onSubtextComplete,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Snake Image
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/no_recents.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Spacer(),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFFFE760,
                    ), // Match yellow from designs
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    "Play animation",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator(false),
                _buildIndicator(
                  true,
                ), // Middle one active as per "onboarding-2"
                _buildIndicator(false),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: 40,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFE760) : Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
