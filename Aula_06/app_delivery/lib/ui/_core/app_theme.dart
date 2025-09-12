import 'package:app_delivery/ui/_core/app_colors.dart';
import 'package:flutter/material.dart';

// Cria classe abstrata do tema do app

abstract class AppTheme {
  // Cria variável para armazenar o tema do app
  // Função para copiar o tema do aplicativo
  static ThemeData appTheme = ThemeData.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.black),
      backgroundColor: WidgetStateColor.resolveWith((states){
        if(states.contains(WidgetState.disabled)){
          return Colors.grey;

        }else if(states.contains(WidgetState.pressed)){
          return Color.fromARGB(171,255,164,89);
        }
        return AppColors.mainColor;
      }
    )
  )
  ));
}