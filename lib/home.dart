import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'bloc/camera_bloc.dart';
import 'controller.dart';


class Home extends StatelessWidget {
  final CameraControllerX controller = CameraControllerX();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraBloc(controller),
      child: Scaffold(
        appBar: AppBar(title: Text('Color Detector')),
        body: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state is CameraFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state is CameraInitial || state is CameraCapturing) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: <Widget>[
                // Vista previa de la cámara con un círculo en el centro
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (controller.cameraController != null &&
                          controller.cameraController!.value.isInitialized)
                        CameraPreview(controller.cameraController!),
                      // Círculo en el centro de la vista previa de la cámara
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is CameraReady || state is ColorProcessed)
                  ElevatedButton(
                    onPressed: () => context.read<CameraBloc>().add(CaptureAndProcessColor()),
                    child: Text('Capturar y Analizar Color'),
                  ),
                // Mostrar el color procesado
                if (state is ColorProcessed)
                  Text('Color: ${state.colorName} (${state.colorHex})'),
              ],
            );
          },
        ),
      ),
    );
  }
}
