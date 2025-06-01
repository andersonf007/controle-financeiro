import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_assistant_2608/project/database_management/shared_preferences_services.dart';
import 'package:money_assistant_2608/project/localization/methods.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'custom_toast.dart';

class MainLockScreen extends StatelessWidget {
  const MainLockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenLock(
      correctString: sharedPrefs.passcodeScreenLock,
      onUnlocked: () => AppLock.of(context)!.didUnlock(),
      cancelButton: const Icon(Icons.close, color: Color.fromRGBO(89, 129, 163, 1)),
      title: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(getTranslated(context, 'Please Enter Passcode') ?? 'Please Enter Passcode', style: const TextStyle(color: Color.fromRGBO(71, 131, 192, 1), fontWeight: FontWeight.w500, fontSize: 20))),
      config: const ScreenLockConfig(backgroundColor: Color.fromRGBO(210, 234, 251, 1)),
      secretsConfig: SecretsConfig(secretConfig: SecretConfig(borderColor: Color.fromRGBO(79, 94, 120, 1), enabledColor: Color.fromRGBO(89, 129, 163, 1))),
      keyPadConfig: KeyPadConfig(buttonConfig: KeyPadButtonConfig(buttonStyle: OutlinedButton.styleFrom(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), backgroundColor: const Color.fromRGBO(71, 131, 192, 1)))),
    );
  }
}

class OtherLockScreen extends StatelessWidget {
  final BuildContext providerContext;
  const OtherLockScreen({required this.providerContext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputController = InputController();

    return Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            screenLockCreate(
              context: context,
              inputController: inputController,
              onConfirmed: (passCode) {
                sharedPrefs.passcodeScreenLock = passCode;
                Navigator.pop(context);
                customToast(context, 'Passcode has been enabled');
              },
              cancelButton: TextButton(
                onPressed: () {
                  providerContext.read<OnSwitch>().onSwitch();
                  Navigator.pop(context);
                },
                child: Text(getTranslated(context, 'Cancel') ?? 'Cancel', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
              ),
              title: Padding(padding: EdgeInsets.only(bottom: 10.h), child: Text(getTranslated(context, 'Please Enter Passcode') ?? 'Please Enter Passcode', style: TextStyle(color: const Color.fromRGBO(71, 131, 192, 1), fontWeight: FontWeight.w500, fontSize: 20.sp))),
              confirmTitle: Text(getTranslated(context, 'Please Re-enter Passcode') ?? 'Please Re-enter Passcode', style: TextStyle(color: const Color.fromRGBO(71, 131, 192, 1), fontWeight: FontWeight.w500, fontSize: 20.sp)),
              config: const ScreenLockConfig(backgroundColor: Color.fromRGBO(210, 234, 251, 1)),
              secretsConfig: SecretsConfig(secretConfig: SecretConfig(borderColor: Color.fromRGBO(79, 94, 120, 1), enabledColor: Color.fromRGBO(89, 129, 163, 1))),
              keyPadConfig: KeyPadConfig(buttonConfig: KeyPadButtonConfig(buttonStyle: OutlinedButton.styleFrom(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), backgroundColor: const Color.fromRGBO(71, 131, 192, 1)))),
            );
          },
          child: const Text('Criar Senha'),
        );
      },
    );
  }
}
