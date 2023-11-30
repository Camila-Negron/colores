part of 'camera_bloc.dart';

// Definición base para los estados de la cámara.
abstract class CameraState {}

// Estado inicial, cuando la cámara aún no se ha inicializado.
class CameraInitial extends CameraState {}

// Estado cuando la cámara está lista para capturar imágenes.
class CameraReady extends CameraState {}

// Estado durante la captura de una imagen.
class CameraCapturing extends CameraState {}

// Estado cuando se ha completado el procesamiento del color.
class ColorProcessed extends CameraState {
  final String colorHex;
  final String colorName;

  ColorProcessed({required this.colorHex, required this.colorName});
}

// Estado para manejar errores generales.
class CameraFailure extends CameraState {
  final String errorMessage;

  CameraFailure({required this.errorMessage});
}
