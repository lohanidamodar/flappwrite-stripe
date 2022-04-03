import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

import 'config.dart' as config;

final client = Client();
final database = Database(client);
String collectionId = 'products';

void main(List<String> arguments) async {
  client
      .setEndpoint(config.endpoint)
      .setProject(config.projectId)
      .setKey(config.apiKey);
  await createCollection();
  await seedData();
}

Future<void> createCollection() async {
  try {
    final collection = await database.createCollection(
        collectionId: collectionId,
        name: 'Products',
        permission: 'collection',
        read: ['role:all'],
        write: []);
    print("collection created");
    await database.createStringAttribute(
      collectionId: collection.$id,
      key: 'name',
      size: 255,
      xrequired: true,
    );
    print("name attribute created");

    // float attribute model class has some issue waiting for release of next version of SDK
    try {
      await database.createFloatAttribute(
        collectionId: collection.$id,
        key: 'price',
        xrequired: true,
      );
      print("price attribute created");
    } on AppwriteException catch (e) {
      print(e.toString());
    }
    await database.createStringAttribute(
      collectionId: collection.$id,
      key: 'imageUrl',
      size: 2048,
      xrequired: false,
    );
    print("imageUrl attribute created");
  } on AppwriteException catch (e) {
    print(e.toString());
  }
}

Future<void> seedData() async {
  final file = File('./bin/data.json');
  List data = jsonDecode(file.readAsStringSync());

  for (final product in data) {
    final doc = await database.createDocument(
      collectionId: collectionId,
      documentId: 'unique()',
      data: product,
    );
    print("document inserted: ${doc.toMap()}");
  }
}
