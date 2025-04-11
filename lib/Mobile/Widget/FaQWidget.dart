import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FAQWidget extends StatefulWidget {
  @override
  _FAQWidgetState createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What happens when I place an order?',
      'answer': 'When you place an order, our team will process it immediately and ensure timely service delivery.',
    },
    {
      'question': 'How do I pay for my order?',
      'answer': 'You can pay online using a debit/credit card, UPI, or choose cash on delivery where applicable.',
    },
    {
      'question': 'How will I get an invoice for the service?',
      'answer': 'An invoice will be sent to your registered email address upon successful payment.',
    },
  ];

  final Set<int> expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: faqs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10,right: 10),
      itemBuilder: (context, index) {
        final faq = faqs[index];
        final isExpanded = expandedIndexes.contains(index);

        return Column(
          children: [
            ListTile(
              dense: true,
              title: Text(
                faq['question']!,
                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    expandedIndexes.remove(index);
                  } else {
                    expandedIndexes.add(index);
                  }
                });
              },
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  faq['answer']!,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            const Divider(),
          ],
        );
      },
    );
  }
}
