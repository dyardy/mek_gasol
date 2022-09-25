/// ========================================
///    Pure Dart Firestore Client Admin
///          (IGNORE THIS FILE)
/// ========================================

// dev_dependencies:
//   googleapis_auth: ^1.3.1
//   googleapis: ^9.2.0

// import 'package:googleapis/firestore/v1.dart';
// import 'package:googleapis_auth/googleapis_auth.dart';
//
// const apiKey = 'AIzaSyCFZwJGPSexxv1vaZRWNlfR8k1MgEoxW-A';
// const projectId = 'mek-gasol';
//
// void main() async {
//   final client = clientViaApiKey(apiKey);
//
//   final firestoreApi = Firestore(FirestoreClient(
//     api: FirestoreApi(client),
//     projectId: projectId,
//   ));
//
//   // final firestore = firestoreApi.projects.databases.documents;
//   //
//   // final result =
//   //     await firestore.listDocuments('projects/$projectId/databases/(default)/documents', 'orders');
//   //
//   // print(jsonEncode(result));
//
//   await firestoreApi.collection('products').get();
// }
//
// class FirestoreClient {
//   final String projectId;
//   final FirestoreApi api;
//
//   const FirestoreClient({
//     required this.projectId,
//     required this.api,
//   });
//
//   String get parent => 'projects/$projectId/databases/(default)/documents';
//
//   Map<String, dynamic> deserializeFields(Map<String, Value> fields) {
//     return fields.map((key, value) => MapEntry(key, _deserializeValue(value)));
//   }
//
//   Map<String, Value> serializeData(Map<String, dynamic> data) {
//     return data.map((key, value) => MapEntry(key, _serializeValue(value)));
//   }
//
//   dynamic _deserializeValue(Value value) {
//     if (value.arrayValue != null) {
//       return value.arrayValue!.values!.map(_deserializeValue).toList();
//     } else if (value.booleanValue != null) {
//       return value.booleanValue!;
//     } else if (value.bytesValue != null) {
//       return null;
//     } else if (value.doubleValue != null) {
//       return value.doubleValue!;
//     } else if (value.geoPointValue != null) {
//       return null;
//     } else if (value.integerValue != null) {
//       return int.parse(value.integerValue!);
//     } else if (value.mapValue != null) {
//       return deserializeFields(value.mapValue!.fields!);
//     } else if (value.nullValue != null) {
//       return null;
//     } else if (value.referenceValue != null) {
//       return null;
//     } else if (value.stringValue != null) {
//       return value.stringValue!;
//     } else if (value.timestampValue != null) {
//       return null;
//     }
//   }
//
//   Value _serializeValue(dynamic data) {
//     return Value(
//       arrayValue: data is List ? ArrayValue(values: data.map(_serializeValue).toList()) : null,
//       booleanValue: data is bool ? data : null,
//       bytesValue: null,
//       doubleValue: data is double ? data : null,
//       geoPointValue: null,
//       integerValue: data is int ? '$data' : null,
//       mapValue: data is Map<String, dynamic> ? MapValue(fields: serializeData(data)) : null,
//       nullValue: data == null ? 'nullValue' : null,
//       referenceValue: null,
//       stringValue: null,
//       timestampValue: null,
//     );
//   }
// }
//
// Map<String, dynamic> _fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
//     snapshot.data();
//
// Map<String, dynamic> _toFirestore(Map<String, dynamic> value) => value;
//
// typedef ToFirestore<T> = Map<String, dynamic> Function(T value);
// typedef FromFirestore<T> = T Function(DocumentSnapshot<Map<String, dynamic>> snapshot);
//
// class Firestore {
//   final FirestoreClient client;
//
//   Firestore(this.client);
//
//   CollectionReference<Map<String, dynamic>> collection(String id) {
//     return CollectionReference(
//       client: client,
//       path: id,
//       fromFirestore: _fromFirestore,
//       toFirestore: _toFirestore,
//     );
//   }
//
//   DocumentReference<Map<String, dynamic>> document(String id) {
//     return DocumentReference(
//       client: client,
//       path: id,
//       fromFirestore: _fromFirestore,
//       toFirestore: _toFirestore,
//     );
//   }
// }
//
// class CollectionReference<T> {
//   final FirestoreClient client;
//   final String path;
//   final ToFirestore<T> toFirestore;
//   final FromFirestore<T> fromFirestore;
//
//   const CollectionReference({
//     required this.client,
//     required this.path,
//     required this.toFirestore,
//     required this.fromFirestore,
//   });
//
//   DocumentReference<T> document(String id) {
//     return DocumentReference(
//       client: client,
//       path: '$path/$id',
//       toFirestore: toFirestore,
//       fromFirestore: fromFirestore,
//     );
//   }
//
//   Future<DocumentSnapshot<T>> add(T data) async {
//     final result = await client.api.projects.databases.documents.createDocument(
//       Document()..fields = client.serializeData(toFirestore(data)),
//       client.parent,
//       path,
//     );
//
//     return SerializableDocumentSnapshot(
//       client: client,
//       toFirestore: toFirestore,
//       fromFirestore: fromFirestore,
//       delegate: result,
//     );
//   }
//
//   Future<QuerySnapshot<T>> get() async {
//     final result = await client.api.projects.databases.documents.listDocuments(client.parent, path);
//
//     return QuerySnapshot(
//       client: client,
//       toFirestore: toFirestore,
//       fromFirestore: fromFirestore,
//       delegate: result,
//     );
//   }
//
//   CollectionReference<R> withConverter<R>({
//     required FromFirestore<R> fromFirestore,
//     required ToFirestore<R> toFirestore,
//   }) {
//     return CollectionReference<R>(
//       client: client,
//       path: path,
//       fromFirestore: fromFirestore,
//       toFirestore: toFirestore,
//     );
//   }
// }
//
// class DocumentReference<T> {
//   final FirestoreClient client;
//   final String path;
//   final ToFirestore<T> toFirestore;
//   final FromFirestore<T> fromFirestore;
//
//   const DocumentReference({
//     required this.client,
//     required this.path,
//     required this.toFirestore,
//     required this.fromFirestore,
//   });
//
//   Future<DocumentSnapshot<T>> set(T data) async {
//     final result = await client.api.projects.databases.documents.createDocument(
//       Document()..fields = client.serializeData(toFirestore(data)),
//       client.parent,
//       path,
//     );
//
//     return SerializableDocumentSnapshot(
//       client: client,
//       toFirestore: toFirestore,
//       fromFirestore: fromFirestore,
//       delegate: result,
//     );
//   }
//
//   Future<DocumentSnapshot<T>> get() async {
//     final result = await client.api.projects.databases.documents.get('${client.parent}/$path');
//
//     return SerializableDocumentSnapshot(
//       client: client,
//       toFirestore: toFirestore,
//       fromFirestore: fromFirestore,
//       delegate: result,
//     );
//   }
//
//   Future<void> delete() async {
//     await client.api.projects.databases.documents.delete('${client.parent}/$path');
//   }
//
//   DocumentReference<R> withConverter<R>({
//     required FromFirestore<R> fromFirestore,
//     required ToFirestore<R> toFirestore,
//   }) {
//     return DocumentReference<R>(
//       client: client,
//       path: path,
//       fromFirestore: fromFirestore,
//       toFirestore: toFirestore,
//     );
//   }
// }
//
// class QuerySnapshot<T> {
//   final ListDocumentsResponse _delegate;
//   final FirestoreClient client;
//   final ToFirestore<T> toFirestore;
//   final FromFirestore<T> fromFirestore;
//
//   const QuerySnapshot({
//     required this.client,
//     required this.toFirestore,
//     required this.fromFirestore,
//     required ListDocumentsResponse delegate,
//   }) : _delegate = delegate;
//
//   List<DocumentSnapshot<T>> get docs {
//     return _delegate.documents!.map((e) {
//       return SerializableDocumentSnapshot(
//         client: client,
//         toFirestore: toFirestore,
//         fromFirestore: fromFirestore,
//         delegate: e,
//       );
//     }).toList();
//   }
// }
//
// abstract class DocumentSnapshot<T> {
//   final FirestoreClient client;
//
//   const DocumentSnapshot({
//     required this.client,
//   });
//
//   DocumentReference<T> get reference;
//
//   T data();
// }
//
// class SerializableDocumentSnapshot<T> extends DocumentSnapshot<T> {
//   final Document _delegate;
//   final ToFirestore<T> toFirestore;
//   final FromFirestore<T> fromFirestore;
//
//   const SerializableDocumentSnapshot({
//     required super.client,
//     required this.toFirestore,
//     required this.fromFirestore,
//     required Document delegate,
//   }) : _delegate = delegate;
//
//   @override
//   DocumentReference<T> get reference => DocumentReference(
//         client: client,
//         path: _delegate.name!,
//         toFirestore: toFirestore,
//         fromFirestore: fromFirestore,
//       );
//
//   @override
//   T data() => fromFirestore(_RawDocumentSnapshot(client: client, delegate: _delegate));
// }
//
// class _RawDocumentSnapshot extends DocumentSnapshot<Map<String, dynamic>> {
//   final Document _delegate;
//
//   const _RawDocumentSnapshot({
//     required super.client,
//     required Document delegate,
//   }) : _delegate = delegate;
//
//   @override
//   DocumentReference<Map<String, dynamic>> get reference => DocumentReference(
//         client: client,
//         path: _delegate.name!,
//         fromFirestore: _fromFirestore,
//         toFirestore: _toFirestore,
//       );
//
//   @override
//   Map<String, dynamic> data() => client.deserializeFields(_delegate.fields!);
// }
