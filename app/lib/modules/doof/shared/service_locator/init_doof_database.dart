import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/logger.dart';

extension DoofDatabase on GetIt {
  static const _nextVersion = _Version(0, 1);

  Future<void> initDoofDatabase() async {
    final firestore = get<FirebaseFirestore>();

    final optionsDoc = firestore.collection('apps').doc('doof');
    final optionsSnapshot = await optionsDoc.get();
    final currentVersion = _Version.parse(optionsSnapshot.data()!['databaseVersion']);

    lg.config('DatabaseVersion: $currentVersion -> $_nextVersion');

    if (_nextVersion.minor > currentVersion.minor) {
      lg.config('Database Setup...!');

      lg.config('Database Cleaning!');
      await Future.wait([
        _elaborate('Cleaning: Products', [_cleanCollection(ProductsRepository.collection)]),
        _elaborate('Cleaning: Additions', [_cleanCollection(AdditionsRepository.collection)]),
      ]);
      lg.config('Database Cleaned!');

      final spaghettiWithEgg = ProductDto(
        id: '2CEsGXmUT6GcDMhKHD7C',
        title: 'Spaghetti all\'uovo',
        description: 'Spaghetti all\'uovo saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      );
      final spaghettiUdon = ProductDto(
        id: 'eCO73liFjEGHEvIaF8QL',
        title: 'Spaghetti Udon',
        description: 'Spaghetti udon saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      );
      final riceDumplings = ProductDto(
        id: 'OU54VLbMSMRnMEIme0nu',
        title: 'Gnocchi Di Riso',
        description: 'Gnocchi di riso saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
      );
      final cantoneseRice = ProductDto(
        id: 'KFdKDYCv5CrdEkMPlPPY',
        title: 'Riso Alla Cantonese',
        description: 'Riso saltato con uova, prosciutto cotto e piselli.',
        price: Decimal.parse('3.60'),
      );
      final riceWithMixedVegetables = ProductDto(
        id: 'eOuccbWyv3hXdaQTCUxm',
        title: 'Riso Con Verdure Miste',
        description: 'Riso saltato con uova, carote, zucchine e piselli.',
        price: Decimal.parse('3.60'),
      );
      final riceWithShrimp = ProductDto(
        id: 'tGVLMvzKY8FpgirYVK6P',
        title: 'Riso Con Gamberetti',
        description: 'Riso saltato con uova, piselli e gamberetti.',
        price: Decimal.parse('4.40'),
      );

      final firstCourses = [
        spaghettiWithEgg,
        spaghettiUdon,
        riceDumplings,
        cantoneseRice,
        riceWithMixedVegetables,
        riceWithShrimp
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
          price: Decimal.parse('10.50'),
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

      await Future.wait([
        _elaborate('Updating: Firs Courses', firstCourses.map(get<ProductsRepository>().save)),
        _elaborate('Updating: Additions', additions.map(get<AdditionsRepository>().save)),
        _elaborate('Updating: Ravioli', ravioli.map(get<ProductsRepository>().save)),
      ]);
      lg.config('Database Updated!');
    }
    if (_nextVersion.major > currentVersion.major) {
      // Delete user data database
      lg.config('Database Deleted!');
    }

    if (currentVersion != _nextVersion) {
      await optionsDoc.update({'databaseVersion': _nextVersion.toString()});
      lg.config('Database Setup Completed!');
    }
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

class _Version {
  final int major;
  final int minor;

  const _Version(this.major, this.minor);

  factory _Version.parse(String source) {
    final versions = source.split('.');
    if (versions.length != 2) throw 'Invalid version';
    return _Version(int.parse(versions.first), int.parse(versions.last));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Version &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor;

  @override
  int get hashCode => major.hashCode ^ minor.hashCode;

  @override
  String toString() => '$major.$minor';
}
