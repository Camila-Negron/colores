
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import '../controller.dart';
part 'camera_event.dart';
part 'camera_state.dart';


class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraControllerX cameraControllerX;

  CameraBloc(this.cameraControllerX) : super(CameraInitial()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<CaptureAndProcessColor>(_onCaptureAndProcessColor);
  }

  void _onInitializeCamera(InitializeCamera event, Emitter<CameraState> emit) async {
    try {
      await cameraControllerX.initializeCamera();
      if (cameraControllerX.cameraController != null && cameraControllerX.cameraController!.value.isInitialized) {
        emit(CameraReady());
      } else {
        emit(CameraFailure(errorMessage: 'Error initializing camera'));
      }
    } catch (error) {
      emit(CameraFailure(errorMessage: error.toString()));
    }
  }

  void _onCaptureAndProcessColor(CaptureAndProcessColor event, Emitter<CameraState> emit) async {
    emit(CameraCapturing());
    try {
      await cameraControllerX.captureColor();
      emit(ColorProcessed(
          colorHex: cameraControllerX.colorHex.value,
          colorName: 'Processed Color' // Aquí puedes integrar una lógica para obtener el nombre del color si es necesario
      ));
    } catch (error) {
      emit(CameraFailure(errorMessage: error.toString()));
    }
  }
}
