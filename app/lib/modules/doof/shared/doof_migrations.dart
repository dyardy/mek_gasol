import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/repositories/ingredients_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/logger.dart';

class DoofDatabase {
  FirebaseFirestore get firestore => get();

  Future<void> migrateMenu() async {
    lg.config('Database Updating!');

    lg.config('Database Cleaning!');
    await Future.wait([
      _elaborate('Cleaning: Products', [_cleanCollection(ProductsRepository.collection)]),
      _elaborate('Cleaning: Additions', [_cleanCollection(AdditionsRepository.collection)]),
      _elaborate('Cleaning: Ingredients', [_cleanCollection(IngredientsRepository.collection)]),
    ]);
    lg.config('Database Cleaned!');

    final firstCourses = [
      ProductDto(
        id: '2CEsGXmUT6GcDMhKHD7C',
        title: 'Spaghetti all\'uovo',
        description: 'Spaghetti all\'uovo saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'eCO73liFjEGHEvIaF8QL',
        title: 'Spaghetti Udon',
        description: 'Spaghetti udon saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'OU54VLbMSMRnMEIme0nu',
        title: 'Gnocchi Di Riso',
        description: 'Gnocchi di riso saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'KFdKDYCv5CrdEkMPlPPY',
        title: 'Riso Alla Cantonese',
        description: 'Riso saltato con uova, prosciutto cotto e piselli.',
        price: Decimal.parse('3.60'),
      ),
      ProductDto(
        id: 'eOuccbWyv3hXdaQTCUxm',
        title: 'Riso Con Verdure Miste',
        description: 'Riso saltato con uova, carote, zucchine e piselli.',
        price: Decimal.parse('3.60'),
      ),
      ProductDto(
        id: 'tGVLMvzKY8FpgirYVK6P',
        title: 'Riso Con Gamberetti',
        description: 'Riso saltato con uova, piselli e gamberetti.',
        price: Decimal.parse('4.40'),
      ),
    ];
    final firsCourseIds = firstCourses.map((e) => e.id).toList();

    final additions = [
      AdditionDto(
        id: 'koyuDvKDhL1imLcgjHr5',
        productIds: firsCourseIds,
        title: 'Pollo',
        description: 'Aggiunta di pollo',
        price: Decimal.parse('1.50'),
      ),
      AdditionDto(
        id: 'VEI2ub9FOosr2GK6jMMc',
        productIds: firsCourseIds,
        title: 'Maiale',
        description: 'Aggiunta di maiale',
        price: Decimal.parse('1.50'),
      ),
      AdditionDto(
        id: 'DsqZgv5vO6fKmk2e0pYV',
        productIds: firsCourseIds,
        title: 'Manzo',
        description: 'Pezzettini di manzo saltati in padella.',
        price: Decimal.parse('1.80'),
      ),
      AdditionDto(
        id: 'J4XU2yRjpaTzYzNLTRRM',
        productIds: firsCourseIds,
        title: 'Gamberetti',
        description: 'Aggiunta di gamberetti',
        price: Decimal.parse('1.80'),
      ),
      AdditionDto(
        id: 'MV0JieRZm6GREnaUM7Ip',
        productIds: firsCourseIds,
        title: 'Uovo Extra',
        description: 'Aggiunta di un uovo strapazzato',
        price: Decimal.parse('0.70'),
      ),
      AdditionDto(
        id: 'Dw50GWoFNGuIxc1N7sMB',
        productIds: firsCourseIds,
        title: 'Zucchine Extra',
        description: 'Aggiunta di una porzione di zucchine',
        price: Decimal.parse('0.50'),
      ),
      AdditionDto(
        id: '98L1YkegtKjBi1fXPY1d',
        productIds: firsCourseIds,
        title: 'Carote Extra',
        description: 'Aggiunta di una porzione di carote',
        price: Decimal.parse('0.50'),
      ),
      AdditionDto(
        id: 'fL6SSIIhwD5CZ7C2Httd',
        productIds: firsCourseIds,
        title: 'Cavolo Extra',
        description: 'Aggiunta di una porzione di cavolo',
        price: Decimal.parse('0.50'),
      ),
    ];

    final ingredients = [
      IngredientDto(
        id: 'MYfBAEtoVzUrFQQLFxyP',
        productIds: firsCourseIds,
        title: 'Salsa Di Soia',
        description: '',
        minLevel: 0,
        maxLevel: 4,
      ),
      IngredientDto(
        id: 'AJaYFe7rBgt3cODa0Yec',
        productIds: firsCourseIds,
        title: 'Salsa Piccante',
        description: '',
        minLevel: 0,
        maxLevel: 4,
      ),
    ];

    final ravioli = [
      ProductDto(
        id: 'tIGXj4JPigpru7r1HTqT',
        title: 'Ravioli Con Verdure',
        description: 'Ravioli al vapore con ripieno alle verdure (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: '3ED7ABZLejHEwVx5d9GU',
        title: 'Ravioli Di Carne',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: 'n2MHLI4GfWCfPauCpigP',
        title: 'Xiao Long Bao',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: 'B8paUtP7m1p2LeVI9pAG',
        title: 'Shao Mai',
        description: 'Ravioli al vapore con ripieno ai gamberetti (6 pz).',
        price: Decimal.parse('4.20'),
      ),
    ];

    // TODO: Add Bevande products

    await Future.wait([
      _elaborate('Updating: Firs Courses', firstCourses.map(get<ProductsRepository>().save)),
      _elaborate('Updating: Additions', additions.map(get<AdditionsRepository>().save)),
      _elaborate('Updating: Ingredients', ingredients.map(get<IngredientsRepository>().save)),
      _elaborate('Updating: Ravioli', ravioli.map(get<ProductsRepository>().save)),
    ]);
    lg.config('Database Updated!');
  }

  Future<void> migrateOrders() async {
    // Delete user data database
    lg.config('Database Deleting!');
    await Future.wait([
      _elaborate('Deleting: Orders', [_cleanCollection(OrdersRepository.collection)]),
    ]);
    lg.config('Database Deleted!');
  }

  Future _cleanCollection(String id) async {
    final docs = await get<FirebaseFirestore>().collection(id).get();
    return await Future.wait(docs.docs.map((e) async => await e.reference.delete()));
  }

  Future<void> _elaborate(String name, Iterable<Future> futures) async {
    lg.config(name);
    await Future.wait(futures);
  }
}
