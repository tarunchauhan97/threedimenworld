import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Three Dimensional World Flutter 3D'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;
  String choosenAsset = assetsList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ThreeDimenView(
              controller: controller,
              assetSelect: choosenAsset,
              key: ValueKey(choosenAsset),
            ),
            Positioned(
              top: 10,
              width: MediaQuery.of(context).size.width,
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: 120,
                child: DropdownButton<String>(
                  items: assetsList.map<DropdownMenuItem<String>>(
                    (e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    },
                  ).toList(),
                  isExpanded: false,
                  value: choosenAsset,
                  underline: const SizedBox.shrink(),
                  elevation: 4,
                  onChanged: (String? value) {
                    setState(() {
                      choosenAsset = value!;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width * .90,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            controller.playAnimation();
                          },
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {
                            controller.pauseAnimation();
                          },
                          icon: const Icon(
                            Icons.pause_circle_filled_rounded,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {
                            controller.resetAnimation();
                          },
                          icon: const Icon(
                            Icons.replay_circle_filled_rounded,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () async {
                            List<String> availableAnimations =
                                await controller.getAvailableAnimations();
                            print(
                                'Animations : $availableAnimations -- Length : ${availableAnimations.length}');
                            chosenAnimation = await showPickerDialog(
                                availableAnimations, chosenAnimation);
                            controller.playAnimation(
                                animationName: chosenAnimation);
                          },
                          icon: const Icon(
                            Icons.format_list_bulleted_outlined,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () async {
                            List<String> availableTextures =
                                await controller.getAvailableTextures();
                            print(
                                'Textures : $availableTextures -- Length : ${availableTextures.length}');
                            chosenTexture = await showPickerDialog(
                                availableTextures, chosenTexture);
                            controller.setTexture(
                                textureName: chosenTexture ?? '');
                          },
                          icon: const Icon(
                            Icons.list_alt_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            controller.setCameraOrbit(20, 20, 5);
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {
                            controller.resetCameraOrbit();
                          },
                          icon: const Icon(
                            Icons.cameraswitch_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showPickerDialog(List<String> inputList,
      [String? chosenItem]) async {
    return await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: inputList.length,
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, inputList[index]);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}'),
                        Text(inputList[index]),
                        Icon(chosenItem == inputList[index]
                            ? Icons.check_box
                            : Icons.check_box_outline_blank)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider(
                  color: Colors.grey,
                  thickness: 0.6,
                  indent: 10,
                  endIndent: 10,
                );
              },
            ),
          );
        });
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key, required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.5),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.blue,
        padding: const EdgeInsets.all(10),
        iconSize: 40,
        splashColor: Colors.blue,
      ),
    );
  }
}

class ThreeDimenView extends StatefulWidget {
  ThreeDimenView({
    super.key,
    this.assetSelect,
    required this.controller,
    // required this.stateUpdate,
  });
  final String? assetSelect;

  final Flutter3DController controller;

  // final Function stateUpdate;

  @override
  State<ThreeDimenView> createState() => ThreeDimenViewState();
}

class ThreeDimenViewState extends State<ThreeDimenView> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flutter3DViewer(
      progressBarColor: Colors.blueAccent,
      controller: widget.controller,
      src: widget.assetSelect ?? 'assets/business_man.glb',
    );
  }
}

final List<String> assetsList = [
  'assets/vazcar.glb',
  'assets/business_man.glb',
  'assets/sheen_chair.glb',
  'assets/astronaut.glb',
  'assets/house.glb',
  'assets/plane.glb',
  'assets/wolvic_3d_model.glb',
  'assets/bulldozers.glb',
  'assets/desertbuild.glb',
  'assets/machine_gun.glb',
];



//src: 'assets/sheen_chair.glb', //3D model with different textures
// src:
//     'https://modelviewer.dev/shared-assets/models/Astronaut.glb',


//https://modelviewer.dev/shared-assets/models/Astronaut.glb