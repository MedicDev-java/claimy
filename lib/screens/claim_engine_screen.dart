import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../models/benefit.dart';
import '../services/pdf_service.dart';
import '../services/email_service.dart';

class ClaimEngineScreen extends StatefulWidget {
  final Benefit benefit;
  const ClaimEngineScreen({super.key, required this.benefit});

  @override
  State<ClaimEngineScreen> createState() => _ClaimEngineScreenState();
}

class _ClaimEngineScreenState extends State<ClaimEngineScreen> {
  int _currentStep = 0;
  final List<String> _answers = ['', '', ''];
  bool _isGenerating = false;

  // Mock adaptive questions based on perk type
  List<String> get _questions {
    if (widget.benefit.category == 'Phone') {
      return [
        'What happened to your phone? (e.g., Cracked screen, Theft)',
        'When did the incident occur?',
        'Do you have a police report or repair estimate?',
      ];
    } else if (widget.benefit.category == 'Travel') {
      return [
        'What was the reason for the delay? (e.g., Weather, Mechanical)',
        'How many hours was the delay?',
        'Did you receive any compensation from the airline?',
      ];
    }
    return [
      'Please describe the incident in detail.',
      'What is the estimated value of the loss/damage?',
      'Do you have the original receipt?',
    ];
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _generateClaim();
    }
  }

  void _generateClaim() async {
    setState(() => _isGenerating = true);
    final startTime = DateTime.now();

    // 1. Generate PDF
    final file = await PdfService.generateClaimPdf(
      benefit: widget.benefit,
      answers: _answers,
      userName: 'John Doe', // Placeholder for logged-in user
    );

    // 2. Track Metrics (Mock logging)
    final endTime = DateTime.now();
    final processingTime = endTime.difference(startTime).inMilliseconds;
    debugPrint('METRIC: Claim Processing Time: ${processingTime}ms');
    debugPrint('METRIC: Successful Form Generation: true');

    if (mounted) {
      setState(() => _isGenerating = false);
      if (file != null) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error generating claim form.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeService.slate800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Claim Generated!', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your official claim form has been auto-filled and an email template is ready to send.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to library/dashboard
            },
            child: const Text('Done', style: TextStyle(color: ThemeService.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              EmailService.sendClaimEmail(
                benefit: widget.benefit,
                answers: _answers,
                userName: 'John Doe',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeService.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.slate900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('New Claim', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isGenerating ? _buildLoadingState() : _buildQuestionFlow(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: ThemeService.primary),
          const SizedBox(height: 24),
          const Text(
            'Auto-filling Claim Forms...',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'We are preparing your documents.',
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionFlow() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Dots
          Row(
            children: List.generate(3, (index) => _buildProgressDot(index)),
          ),
          const SizedBox(height: 32),
          Text(
            widget.benefit.perkName,
            style: const TextStyle(color: ThemeService.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _questions[_currentStep],
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => _answers[_currentStep] = val,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
              filled: true,
              fillColor: ThemeService.slate800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeService.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(_currentStep < 2 ? 'Next' : 'Generate Claim'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDot(int index) {
    final isActive = index == _currentStep;
    final isDone = index < _currentStep;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: isActive || isDone ? ThemeService.primary : Colors.white10,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
