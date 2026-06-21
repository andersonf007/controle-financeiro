import 'dart:async';

import 'package:controle_financeiro/project/auth_services/firebase_erros.dart';
import 'package:controle_financeiro/project/classes/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<FirebaseApp> initializeFireBase() async {
    return await Firebase.initializeApp();
  }

  static Future<User?> googleSignIn({required BuildContext context}) async {
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // 1. Tenta login silencioso primeiro
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      // 2. Se não funcionou, abre o seletor de conta
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // 3. Na v6, authentication é assíncrono (com await)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Cria a credencial do Firebase com idToken + accessToken
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user;

    } on FirebaseException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        customToast(context, 'A conta já existe com outra credencial.');
      } else if (e.code == 'invalid-credential') {
        customToast(context, 'Erro ao acessar credenciais. Tente novamente.');
      } else {
        customToast(context, 'Erro Firebase: ${e.message}');
      }
    } catch (e) {
      customToast(context, 'Erro no login com Google. Tente novamente.');
    }

    return user;
  }

  static Future<void> googleSignOut({required BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      customToast(context, 'Erro ao sair. Tente novamente.');
    }
  }

  static Future<String?> loginUser(String email, String senha) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return getErrorString(e.code);
    }
  }

  static Future<String?> signupUser(String email, String senha) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);
      if (userCredential.user == null) {
        return 'Erro ao criar usuário. Tente novamente.';
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return getErrorString(e.code);
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}