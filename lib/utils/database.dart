import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_in.dart';

class Database {
  List<String> tracks = [
    'beginners',
    'power yoga',
    'immunity booster',
    'yoga in pregnancy',
    'insomnia',
    'cardiovascular yoga',
    'yoga for migraine',
    'yoga for asthma',
  ];

  Map<String, List<Set<String>>> poses = {
    'beginners': [
      {'mountain', 'tadasana'},
      {'tree', 'vrikshasana'},
      {'downward facing dog', 'adho mukha svanasana'},
      {'triangle', 'trikonasana'},
      {'cobra', 'bhujangasana'},
      {'child', 'shishuasana'},
      {'easy', 'sukhasana'},
    ],
    'power yoga': [
      {'half moon', 'ardha chandrasana'},
      {'boat', 'paripurna navasana'},
      {'camel', 'ustrasana'},
      {'locust', 'salabhasana'},
      {'plank', 'chaturanga dandasana'},
      {'downward facing dog', 'adho mukha svanasana'},
      {'chair', 'utkatasana'}
    ],
    'immunity booster': [
      {'triangle', 'trikonasana'},
      {'cobra', 'bhujangasana'},
      {'tree', 'vrikshasana'},
      {'mountain', 'tadasana'},
      {'fish', 'matsyasana'}
    ],
    'yoga in pregnancy': [
      {'mountain', 'tadasana'},
      {'triangle', 'trikonasana'},
      {'warrior', 'virabhadrasana'},
      {'easy', 'sukhasana'},
      {'cat-cow', 'marjaryasana'},
      {'forward bend', 'uttanasana'},
      {'corpse', 'shavasana'}
    ],
    'insomnia': [
      {'dynamic forward-fold sequence', 'ardha uttanasana to uttanasana'},
      {'ragdoll', 'ardha utkatasana'},
      {'downward-facing dog', 'adho mukha svanasana'},
      {'cat-cow', 'marjaryasana'},
      {'hypnotic sphinx', 'salamba bhujangasan'},
      {'seated forward bend', 'paschimottanasana'},
      {'legs-up-the-wall', 'viparita karani'},
    ],
    'cardiovascular yoga': [
      {'extended triangle', 'utthita trikonasana'},
      {'seated forward bend', 'paschimottanasana'},
      {'half spinal twist', 'ardha matsyendrasana'},
      {'cow face', 'gomukhasana'},
      {'bridge', 'setu bandhasana'}
    ],
    'yoga for migraine': [
      {'downward facing dog', 'adho mukha svanasana'},
      {'wide-legged forward bend', 'prasarita padottanasana'},
      {'child', 'shishuasana'},
      {'head to knee', 'janu sirsasana'},
      {'standing forward bend', 'hastapadasana'},
    ],
    'yoga for asthma': [
      {'easy', 'sukhasana'},
      {'staff', 'dandasana'},
      {'seated wide angle', 'upavistha konasana'},
      {'forward bend', 'uttanasana'},
      {'butterfly', 'baddha konasana'},
    ]
  };

  Future<void> storeUserData({
    @required String userName,
    @required String gender,
    @required int age,
  }) async {
    DocumentReference documentReferencer =
        documentReference.collection('user_info').document(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "image_url": imageUrl,
      "name": userName,
      "gender": gender,
      "age": age,
    };
    print('DATA:\n$data');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await documentReferencer.setData(data).whenComplete(() {
      print("User Info added to the database");
      prefs.setBool('details_uploaded', true);
    }).catchError((e) => print(e));
  }

  uploadTracks() async {
    // beginners
    int id = 1;
    poses.forEach((key, value) async {
      DocumentReference documentReferencer =
          documentReference.collection('tracks').document(key);

      Map<String, dynamic> name = <String, dynamic>{
        "id": id,
        "name": key,
      };
      id = id + 1;

      await documentReferencer.setData(name).whenComplete(() {
        print("$key track added to the database");
      }).catchError((e) => print(e));

      value.forEach((element) async {
        DocumentReference poseDocs = documentReferencer
            .collection('poses')
            .document(element.elementAt(0));

        Map<String, String> data = <String, String>{
          "title": element.elementAt(0),
          "sub": element.elementAt(1),
        };

        await poseDocs.setData(data).whenComplete(() {
          print("${element.elementAt(0)} added to the database");
        }).catchError((e) => print(e));
      });
    });
  }

  // Future getProducts() async {
  //   QuerySnapshot productQuery =
  //       await documentReference.collection('departments').getDocuments();

  //   return productQuery.documents;
  // }

  retrieveUserInfo() async {
    DocumentSnapshot userInfo =
        await documentReference.collection('user_info').document(uid).get();

    return userInfo;
  }

  retrieveTracks() async {
    QuerySnapshot tracksQuery = await documentReference
        .collection('tracks')
        .orderBy('id', descending: false)
        .getDocuments();

    return tracksQuery.documents;
  }

  retrievePoses({@required String trackName}) async {
    QuerySnapshot posesQuery = await documentReference
        .collection('tracks')
        .document(trackName)
        .collection('poses')
        .getDocuments();

    return posesQuery.documents;
  }
}
