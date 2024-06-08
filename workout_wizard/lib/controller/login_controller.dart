import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_wizard/model/usuario.dart';
import '../view/util.dart';

class LoginController {
  //
  // CRIAR CONTA
  // Adiciona a conta de um novo usuário no serviço Firebase Authentication
  //
  criarConta(context, String email, String senha, Usuario usuario) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      String uid = resultado.user!.uid;
      usuario.id = uid;
      FirebaseFirestore.instance
          .collection('usuario')
          .doc(uid)
          .set(usuario.toJson())
          .then((_) {
        sucesso(context, 'Usuário criado com sucesso!');
        Navigator.pop(context);
      }).catchError((erro) {
        erro(context, 'Erro ao adicionar usuário!');
      });
    }).catchError((e) {
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // LOGIN
  //
  login(context, String email, String senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'avaliacao');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-credential':
          erro(context, 'Email e/ou senha inválida');
          break;
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  Future<Usuario> pegarUsuario() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('usuario')
        .doc(uid)
        .get()
        .then((onValue) {
      if (onValue.exists) {
        return Usuario.fromJson(onValue.data() as Map<String, dynamic>);
      } else {
        throw Exception('Usuário não encontrado no Firestore.');
      }
    });
  }

  //
  // ESQUECEU A SENHA
  //
  esqueceuSenha(context, String email) {
    if (email.isNotEmpty) {
      FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      )
          .then((_) {
        sucesso(context, 'Email enviado com sucesso!');
      }).catchError((_) {
        erro(context, 'Não foi possível enviar o e-mail');
      });
    } else {
      erro(context, 'Informe um email para enviar o reset de senha.');
    }
  }

  //
  // LOGOUT
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // ID do Usuário Logado
  //
  idUsuario() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
