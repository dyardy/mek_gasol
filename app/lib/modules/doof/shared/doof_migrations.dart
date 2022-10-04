import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/categories/dto/category_dto.dart';
import 'package:mek_gasol/modules/doof/features/categories/repositories/categories_repository.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/repositories/ingredients_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/logger.dart';

class DoofDatabase {
  FirebaseFirestore get firestore => get();

  Future<void> migrateMenu() async {
    lg.config('Database Updating!');

    await _elaborate('Database Cleaning!', [
      _cleanCollections({
        CategoriesRepository.collection: {},
        ProductsRepository.collection: {},
        AdditionsRepository.collection: {},
        IngredientsRepository.collection: {},
      })
    ]);
    lg.config('Database Cleaned!');

    const firstCoursesCategory = CategoryDto(
      id: 'qis6JTiLNl0Cdfz2D0Wh',
      weight: 0,
      title: 'Primi Piatti',
    );
    const ravioliCategory = CategoryDto(
      id: '1hbbRQVurQwZ7JSAu19Z',
      weight: 1,
      title: 'Ravioli',
    );
    const drinksCategory = CategoryDto(
      id: 'J5IU4RRi5Dy5EHyfkSNL',
      weight: 2,
      title: 'Bevande',
    );
    const categories = [firstCoursesCategory, ravioliCategory, drinksCategory];

    final firstCourses = [
      ProductDto(
        id: '2CEsGXmUT6GcDMhKHD7C',
        categoryId: firstCoursesCategory.id,
        title: 'Spaghetti all\'uovo',
        description: 'Spaghetti all\'uovo saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'eCO73liFjEGHEvIaF8QL',
        categoryId: firstCoursesCategory.id,
        title: 'Spaghetti Udon',
        description: 'Spaghetti udon saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'OU54VLbMSMRnMEIme0nu',
        categoryId: firstCoursesCategory.id,
        title: 'Gnocchi Di Riso',
        description: 'Gnocchi di riso saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      ),
      ProductDto(
        id: 'KFdKDYCv5CrdEkMPlPPY',
        categoryId: firstCoursesCategory.id,
        title: 'Riso Alla Cantonese',
        description: 'Riso saltato con uova, prosciutto cotto e piselli.',
        price: Decimal.parse('3.60'),
      ),
      ProductDto(
        id: 'eOuccbWyv3hXdaQTCUxm',
        categoryId: firstCoursesCategory.id,
        title: 'Riso Con Verdure Miste',
        description: 'Riso saltato con uova, carote, zucchine e piselli.',
        price: Decimal.parse('3.60'),
      ),
      ProductDto(
        id: 'tGVLMvzKY8FpgirYVK6P',
        categoryId: firstCoursesCategory.id,
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
        categoryId: ravioliCategory.id,
        title: 'Ravioli Con Verdure',
        description: 'Ravioli al vapore con ripieno alle verdure (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: '3ED7ABZLejHEwVx5d9GU',
        categoryId: ravioliCategory.id,
        title: 'Ravioli Di Carne',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: 'n2MHLI4GfWCfPauCpigP',
        categoryId: ravioliCategory.id,
        title: 'Xiao Long Bao',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: 'B8paUtP7m1p2LeVI9pAG',
        categoryId: ravioliCategory.id,
        title: 'Shao Mai',
        description: 'Ravioli al vapore con ripieno ai gamberetti (6 pz).',
        price: Decimal.parse('4.20'),
      ),
    ];

    final drinks = [
      ProductDto(
        id: 'vBTp1rEYs444Tj7Rp2pv',
        categoryId: drinksCategory.id,
        title: 'Acqua Naturale',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('1.00'),
      ),
      ProductDto(
        id: 'rFrsKjDdzI0HVTGruZKQ',
        categoryId: drinksCategory.id,
        title: 'Acqua Frizzante',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('3.50'),
      ),
      ProductDto(
        id: 'Ng4gG1hAu2Be2ws87D9P',
        categoryId: drinksCategory.id,
        title: 'Té Al Limone',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
      ),
      ProductDto(
        id: '2CRDqwzWc9uDcgGqIyD0',
        categoryId: drinksCategory.id,
        title: 'Té Alla Pesca',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
      ),
      ProductDto(
        id: 'ymvsXJXFNSaFcirWYrlK',
        categoryId: drinksCategory.id,
        title: 'Fanta',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
      ),
      ProductDto(
        id: 'ePrNHHRjEulf10QBNo6F',
        categoryId: drinksCategory.id,
        title: 'Coca Cola',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
      ),
      ProductDto(
        id: 'fnIvuAG2yH50MrT9IL4w',
        categoryId: drinksCategory.id,
        title: 'Redbull',
        description: 'Lattina da 25cl.',
        price: Decimal.parse('3.00'),
      ),
      ProductDto(
        id: 'LLrvqplltLs85UiGAkSw',
        categoryId: drinksCategory.id,
        title: 'Birra Moretti',
        description: 'Bottiglia da 66cl.',
        price: Decimal.parse('3.00'),
      ),
      ProductDto(
        id: 'YKMFDOi5dBCQ7NSMM1mF',
        categoryId: drinksCategory.id,
        title: 'Birra Ichnusa',
        description: 'Bottiglia da 50cl.',
        price: Decimal.parse('3.00'),
      ),
      ProductDto(
        id: '9oik8asfD96W5JMUNzfL',
        categoryId: drinksCategory.id,
        title: 'Birra Tsingtao',
        description: 'Bottiglia da 64cl.',
        price: Decimal.parse('3.00'),
      ),
    ];

    // TODO: Add Bevande products

    await Future.wait([
      _elaborate('Updating: Categories', categories.map(get<CategoriesRepository>().save)),
      _elaborate('Updating: First Courses', firstCourses.map(get<ProductsRepository>().save)),
      _elaborate('Updating: Additions', additions.map(get<AdditionsRepository>().save)),
      _elaborate('Updating: Ingredients', ingredients.map(get<IngredientsRepository>().save)),
      _elaborate('Updating: Ravioli', ravioli.map(get<ProductsRepository>().save)),
      _elaborate('Updating: Drinks', drinks.map(get<ProductsRepository>().save)),
    ]);
    lg.config('Database Updated!');
  }

  Future<void> migrateOrders() async {
    // Delete user data database
    lg.config('Database Deleting!');
    await _elaborate('Deleting: Orders', [
      _cleanCollections({
        OrdersRepository.collection: {OrderProductsRepository.collection: {}}
      })
    ]);
    await _elaborate('Creating: Draft Order', [get<OrdersRepository>().create()]);
    lg.config('Database Deleted!');
  }

  Future _cleanCollections(Map<String, dynamic> ids) async {
    return await Future.wait(ids.keys.map((id) async {
      final children = ids[id];
      final docs = await firestore.collection(id).get();
      return await Future.wait([
        _cleanCollections((children as Map).cast<String, dynamic>()),
        ...docs.docs.map((e) async => await e.reference.delete()),
      ]);
    }));
  }

  Future<void> _elaborate(String name, Iterable<Future> futures) async {
    lg.config(name);
    await Future.wait(futures);
  }
}
