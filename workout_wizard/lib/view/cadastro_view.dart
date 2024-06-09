import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:workout_wizard/controller/login_controller.dart';
import 'package:workout_wizard/model/endereco.dart';
import 'dart:convert';
import 'package:workout_wizard/model/usuario.dart';
import 'package:intl/intl.dart';
import 'package:workout_wizard/view/util.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  var formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  var txtPrimeiroNome = TextEditingController();
  var txtSexo = TextEditingController();
  var txtDataNascimento = TextEditingController();
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
  bool _obscurePassword = true;

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
        erro(context, 'Erro ao buscar o endereço.');
        print(e);
        // Trate o erro conforme necessário
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo cadastro',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 176, 225, 231),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: txtPrimeiroNome,
                  labelText: 'Nome',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtCpf,
                  labelText: 'CPF',
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
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtEmail,
                  labelText: 'E-mail',
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
                const SizedBox(height: 20),
                _buildDropdownField(
                  controller: txtSexo,
                  labelText: 'Sexo',
                  items: ['Masculino', 'Feminino'],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um sexo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDatePickerField(
                  controller: txtDataNascimento,
                  labelText: 'Data de Nascimento',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua data de nascimento.';
                    }
                    if (!_validarDataNascimento(value)) {
                      return 'Informe uma data de nascimento válida.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtCep,
                  labelText: 'CEP',
                  inputFormatters: [MaskTextInputFormatter(mask: '#####-###')],
                  onChanged: (value) {
                    if (value.length == 9) {
                      _buscarEndereco();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um CEP.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtLogradouro,
                  labelText: 'Logradouro',
                  enabled: !isAddressReadOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um logradouro.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtNumero,
                  labelText: 'Número',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um número.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtComplemento,
                  labelText: 'Complemento',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtBairro,
                  labelText: 'Bairro',
                  enabled: !isAddressReadOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um bairro.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtCidade,
                  labelText: 'Cidade',
                  enabled: !isAddressReadOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma cidade.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: txtEstado,
                  labelText: 'Estado',
                  enabled: !isAddressReadOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um estado.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: txtSenha,
                  labelText: 'Senha',
                  onChanged: (value) {
                    setState(() {
                      forca = calcularForcaSenha(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha';
                    }
                    if (!validarRequisitosSenha(value)) {
                      return 'A senha não atende a todos os requisitos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildPasswordCriteria(txtSenha.text),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: forca,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(calcularCor(forca)),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(200, 40),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      DateTime dataNascimento = DateFormat('dd/MM/yyyy')
                          .parse(txtDataNascimento.text);

                      Usuario usuario = Usuario(
                        txtPrimeiroNome.text,
                        txtCpf.text,
                        Endereco(
                          txtLogradouro.text,
                          txtCidade.text,
                          txtEstado.text,
                          txtCep.text,
                          txtNumero.text,
                        ),
                        txtSexo.text,
                        dataNascimento,
                      );
                      LoginController().criarConta(
                          context, txtEmail.text, txtSenha.text, usuario);
                    } else {
                      erro(context, 'Corrija os campos inválidos.');
                    }
                  },
                  child: const Text(
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      enabled: enabled,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      style: const TextStyle(fontSize: 18),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String labelText,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          controller.text = value!;
        });
      },
      validator: validator,
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          // locale: const Locale('pt', 'BR'),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
      validator: validator,
    );
  }

  Widget _buildPasswordCriteria(String password) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordCriterion(
          'Pelo menos 6 caracteres',
          password.length >= 6,
        ),
        _buildPasswordCriterion(
          'Pelo menos uma letra maiúscula',
          password.contains(RegExp(r'[A-Z]')),
        ),
        _buildPasswordCriterion(
          'Pelo menos uma letra minúscula',
          password.contains(RegExp(r'[a-z]')),
        ),
        _buildPasswordCriterion(
          'Pelo menos um número',
          password.contains(RegExp(r'[0-9]')),
        ),
        _buildPasswordCriterion(
          'Pelo menos um caractere especial',
          password.contains(RegExp(r'[!@#\$&*~]')),
        ),
      ],
    );
  }

  Widget _buildPasswordCriterion(String criterion, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check : Icons.close,
          color: met ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          criterion,
          style: TextStyle(color: met ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  bool validarRequisitosSenha(String senha) {
    return senha.length >= 6 &&
        senha.contains(RegExp(r'[A-Z]')) &&
        senha.contains(RegExp(r'[a-z]')) &&
        senha.contains(RegExp(r'[0-9]')) &&
        senha.contains(RegExp(r'[!@#\$&*~]'));
  }

  double calcularForcaSenha(String senha) {
    int comprimento = senha.length;
    int forca = 0;

    if (comprimento >= 6) forca += 1;
    if (senha.contains(RegExp(r'[A-Z]'))) forca += 1;
    if (senha.contains(RegExp(r'[a-z]'))) forca += 1;
    if (senha.contains(RegExp(r'[0-9]'))) forca += 1;
    if (senha.contains(RegExp(r'[!@#\$&*~]'))) forca += 1;

    return forca / 5;
  }

  Color calcularCor(double forca) {
    if (forca <= 0.2) {
      return Colors.redAccent; // Muito fraca
    } else if (forca <= 0.4) {
      return Colors.orangeAccent; // Fraca
    } else if (forca <= 0.6) {
      return Colors.yellowAccent; // Média
    } else if (forca <= 0.8) {
      return Colors.greenAccent.shade100; // Forte
    } else {
      return Colors.greenAccent.shade700; // Muito forte
    }
  }

  bool _validarDataNascimento(String dataNascimento) {
    try {
      DateFormat('dd/MM/yyyy').parse(dataNascimento);
      return true;
    } catch (e) {
      return false;
    }
  }
}
