import 'package:url_launcher/url_launcher.dart';
import '../models/benefit.dart';

class EmailService {
  /// Generates and opens a pre-written email template in the user's default mail app.
  static Future<void> sendClaimEmail({
    required Benefit benefit,
    required List<String> answers,
    required String userName,
  }) async {
    final String subject = 'Benefit Claim: ${benefit.perkName} - $userName';
    
    final String body = '''
Dear Claims Department,

I am submitting a claim for the "${benefit.perkName}" benefit included with my ${benefit.providerName} ${benefit.cardName}.

Details of the incident:
1. ${answers[0]}
2. ${answers[1]}
3. ${answers[2]}

Attached is the completed claim form for your review. Please let me know if any further information is required.

Best regards,
$userName
''';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'claims@${benefit.providerName.toLowerCase().replaceAll(' ', '')}.com',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Could not launch email app');
    }
  }
}
