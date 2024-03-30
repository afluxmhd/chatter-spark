import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/chat_controller.dart';
import '../designs/app_button.dart';

class APIKeyDialog extends ConsumerStatefulWidget {
  const APIKeyDialog({super.key, required this.apiKeytextEditingController});

  final TextEditingController apiKeytextEditingController;

  @override
  ConsumerState<APIKeyDialog> createState() => _APIKeyDialogState();
}

class _APIKeyDialogState extends ConsumerState<APIKeyDialog> {
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 200, bottom: 230, right: 40, left: 40),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Configure API-Key',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 60,
                child: TextField(
                  autocorrect: false,
                  controller: widget.apiKeytextEditingController,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: 'API Key',
                    suffixIcon: IconButton(
                      icon: Icon(widget.apiKeytextEditingController.text.isEmpty ? Icons.copy : Icons.close),
                      onPressed: () async {
                        if (widget.apiKeytextEditingController.text.isEmpty) {
                          final copyFromClipboard = await Clipboard.getData(Clipboard.kTextPlain);
                          widget.apiKeytextEditingController.text = copyFromClipboard!.text ?? '';
                        } else {
                          widget.apiKeytextEditingController.clear();
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Text(
                'Your API key is required. \nPlease paste it from the clipboard',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 56),
              AppButton(
                label: 'Configure',
                onTap: () {
                  ref
                      .read(chatControllerProvider.notifier)
                      .configureAPIKey(context, widget.apiKeytextEditingController.text.trim());
                },
              ),
            ],
          ),
        ),
      );
}
