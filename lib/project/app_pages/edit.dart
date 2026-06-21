import 'package:controle_financeiro/project/classes/app_bar.dart';
import 'package:controle_financeiro/project/classes/constants.dart';
import 'package:controle_financeiro/project/classes/input_model.dart';
import 'package:controle_financeiro/project/localization/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'input.dart';

//essa  classe é usada para editar uma entrada existente, ele encaminhas os dados do modelo de entrada para o widget AddEditInput, que é responsável por exibir o formulário de edição.
class Edit extends StatelessWidget {
  static final _formKey3 = GlobalKey<FormState>(debugLabel: '_formKey3');
  final InputModel? inputModel;
  final IconData categoryIcon;
  const Edit({this.inputModel, required this.categoryIcon});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue1,
      appBar: BasicAppBar(getTranslated(context, 'Edit')!),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: PanelForKeyboard(AddEditInput(formKey: _formKey3, inputModel: this.inputModel, categoryIcon: this.categoryIcon)),
      ),
    );
  }
}
