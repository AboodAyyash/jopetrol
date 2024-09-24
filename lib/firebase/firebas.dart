import 'package:cloud_firestore/cloud_firestore.dart';

Future getFirebaseCollectionData({collectionName}) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);
  try {
    QuerySnapshot querySnapshot = await collection.get();
    List idsData = querySnapshot.docs.map((doc) => doc.reference.id).toList();

    List data = querySnapshot.docs.map((doc) => doc.data()).toList();
    List allData = [];
    for (var i = 0; i < idsData.length; i++) {
      allData.insert(i, {'id': idsData[i], 'data': data[i]});
    }
    return allData;
  } catch (e) {
    print("Get Collection Error");
    print(e);
  }
}


Future getFirebaseCollectionCount({collectionName}) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);
  try {
    QuerySnapshot querySnapshot = await collection.get();
    List idsData = querySnapshot.docs.map((doc) => doc.reference.id).toList();

    return idsData.length;
  } catch (e) {
    print("Get Count Error");
    print(e);
  }
}

Future getFirebaseDocumentData({documentId, collectionName}) async {
  final DocumentReference document =
      FirebaseFirestore.instance.collection(collectionName).doc(documentId);
  try {
    dynamic data;
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      data = {'data': snapshot.data(), 'id': snapshot.id};
    });
    return data;
  } catch (e) {
    print("Get Document Error");
    print(e);
  }
}

Future setFirebaseDocumentData({data, collectionName}) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);
  try {
    print("data $data");
    DocumentReference docRef = await collection.add(data);
    return docRef.id;
  } catch (e) {
    print("Set Document Error");
    print(e);
  }
}

Future updateFirebaseDocumentData({id, data, collectionName}) async {
  print("$id, ${data.toString()}, $collectionName");
  CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);
  try {
    await collection.doc(id).update(data);
    return 'success';
  } catch (e) {
    print("Update Document Error");
    print(e);
  }
}

Future searchFirebaseDocument({collectionName, query, where}) async {
  try {
    List<DocumentSnapshot> documentList;
    documentList = (await FirebaseFirestore.instance
            .collection(collectionName)
            .where(where, isGreaterThanOrEqualTo: query)
            .get())
        .docs;

    List allData = [];
    for (var i = 0; i < documentList.length; i++) {
      allData.insert(
          i, {'id': documentList[i].id, 'data': documentList[i].data()});
    }

    return allData;
  } catch (e) {
    print("Search Collection Error");
    print(e);
  }
}
