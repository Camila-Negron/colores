part of 'camera_bloc.dart';
// Definición base para los eventos de la cámara.
abstract class CameraEvent {}

// Evento para inicializar la cámara.
class InitializeCamera extends CameraEvent {}

// Evento para capturar una imagen y procesar el color del área definida.
class CaptureAndProcessColor extends CameraEvent {}
