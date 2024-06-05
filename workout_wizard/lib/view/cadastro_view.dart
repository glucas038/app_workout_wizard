import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/endereco.dart';
import 'dart:convert';

import 'package:workout_wizard/model/usuario.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  var formKey = GlobalKey<FormState>();

  //Controladores dos campos de texto
  var txtPrimeiroNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtCpf = TextEditingController();
  var txtCep = TextEditingController();
  var txtLogradouro = TextEditingController();
  var txtNumero = TextEditingController();
  var txtComplemento = TextEditingController();
  var txtBairro = TextEditingController();
  var txtCidade = TextEditingController();
  var txtEstado = TextEditingController();

  bool isAddressReadOnly = false;
  double forca = 0;

  Future<void> _buscarEndereco() async {
    String cep = txtCep.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      try {
        final response =
            await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            txtLogradouro.text = data['logradouro'];
            txtBairro.text = data['bairro'];
            txtCidade.text = data['localidade'];
            txtEstado.text = data['uf'];
            isAddressReadOnly = true;

            // Mova o foco para o campo de número
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
          });
        } else {
          throw Exception('Erro ao buscar o endereço');
        }
      } catch (e) {
        print(e);
        // Trate o erro conforme necessário
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Novo cadastro',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.greenAccent),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 50, 50, 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: txtPrimeiroNome,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'Primeiro nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um nome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtCpf,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '###.###.###-##')
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um CPF.';
                    }
                    if (!CPFValidator.isValid(value)) {
                      return 'Informe um CPF válido.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtEmail,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um e-mail.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtCep,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [MaskTextInputFormatter(mask: '#####-###')],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um CEP.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 9) {
                      // Quando o campo estiver completo (com a máscara)
                      _buscarEndereco();
                    }
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtLogradouro,
                  style: TextStyle(fontSize: 26),
                  enabled: !isAddressReadOnly,
                  decoration: InputDecoration(
                    labelText: 'Logradouro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um logradouro.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtNumero,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um número.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtComplemento,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'Complemento',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtBairro,
                  style: TextStyle(fontSize: 26),
                  enabled: !isAddressReadOnly,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um bairro.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtCidade,
                  style: TextStyle(fontSize: 26),
                  enabled: !isAddressReadOnly,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma cidade.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtEstado,
                  style: TextStyle(fontSize: 26),
                  enabled: !isAddressReadOnly,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um estado.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txtSenha,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      forca = calcularForcaSenha(value);
                      calcularCor(forca);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha';
                    }
                    if (calcularForcaSenha(value) < 0.4) {
                      return 'Senha muito fraca.';
                    }
                    return null;
                  },
                ),
                LinearProgressIndicator(
                  value: calcularForcaSenha(txtSenha.text),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      calcularCor(calcularForcaSenha(txtSenha.text))),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.black87,
                    minimumSize: Size(200, 40),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Usuario usuario = Usuario(
                        txtPrimeiroNome.text,
                        txtEmail.text,
                        Endereco(
                          txtLogradouro.text,
                          txtCidade.text,
                          txtEstado.text,
                          txtCep.text,
                          txtNumero.text,
                        ),
                      );
                      LoginController().criarConta(
                          context, txtEmail.text, txtSenha.text, usuario);
                    }
                  },
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calcularForcaSenha(String senha) {
    int comprimento = senha.length;
    if (comprimento < 6) {
      return 0.2; // Muito fraca
    } else if (comprimento < 8) {
      return 0.4; // Fraca
    } else if (comprimento < 10) {
      return 0.6; // Média
    } else if (comprimento < 12) {
      return 0.8; // Forte
    } else {
      return 1.0; // Muito forte
    }
  }

  Color calcularCor(double forca) {
    if (forca == 0.2) {
      return Colors.redAccent; // Muito fraca
    } else if (forca == 0.4) {
      return Colors.orangeAccent; // Fraca
    } else if (forca == 0.6) {
      return Colors.yellowAccent; // Média
    } else if (forca == 0.8) {
      return Colors.greenAccent.shade100; // Forte
    } else {
      return Colors.greenAccent.shade700; // Muito forte
    }
  }
}
