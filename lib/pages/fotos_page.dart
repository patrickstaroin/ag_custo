import 'dart:io';

import 'package:ag_custo/repositories/carro_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';

class FotosPage extends StatefulWidget {
  Carro carro;
  FotosPage({Key? key, required this.carro}) : super(key: key);

  @override
  State<FotosPage> createState() => _FotosPageState();
}

class _FotosPageState extends State<FotosPage> {
  late CarroRepository carroRepo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //fotoRepo = context.watch<FotoRepository>();
    carroRepo = context.watch<CarroRepository>();
    //fotoRepo.buscaFotos(widget.carro);
    //tabelaLinkFotos = carroRepo.tabelaFotos;
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: Colors.white),
        title: const Text(
          'Fotos do veículo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan.shade700,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            height: MediaQuery.of(context).size.height * 2.8 / 4,
            child: Consumer<CarroRepository>(
              builder: (context, carroRepo, child) {
                return (widget.carro.tabelaFotos.isEmpty)
                    ? ListTile(
                        leading: Icon(Icons.photo_camera_back),
                        title: Text('Veículo não possui fotos!'))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: widget.carro.tabelaFotos.length,
                        itemBuilder: (context, foto) {
                          return RawMaterialButton(
                            onPressed: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.carro.tabelaFotos[foto]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                /*ListView.separated(
                        shrinkWrap: true,
                        itemCount: widget.carro.tabelaFotos.length,
                        itemBuilder: (context, int foto) => ListTile(
                          leading: Image.network(widget.carro.tabelaFotos[foto],
                              width: 90),
                          title: Text(
                            foto.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => {},
                            icon: const Icon(Icons.swap_vert),
                            color: Colors.white,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        separatorBuilder: (_, __) => const Divider(),
                      );*/
              },
            ),
          ),
          Divider(thickness: 2.0),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  onPressed: () => tirarFoto(),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.white),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'TIRAR NOVA FOTO',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
            child: OutlinedButton(
              onPressed: () => escolherGaleria(),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_search, color: Colors.white),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'ESCOLHER DA GALERIA',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      //final List<XFile>? images = await picker.pickMultiImage();
      if (photo != null) {
        setState(() => carroRepo.uploadFoto(widget.carro, File(photo.path)));
      }
    } catch (e) {
      print(e);
    }
  }

  escolherGaleria() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        setState(() => uploadGaleria(images));
      }
    } catch (e) {
      print(e);
    }
  }

  uploadGaleria(List<XFile> images) {
    images.forEach((foto) async {
      await carroRepo.uploadFoto(widget.carro, File(foto.path));
    });
  }
}
