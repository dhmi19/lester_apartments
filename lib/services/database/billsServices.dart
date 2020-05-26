import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/groceryItem.dart';

class BillsServices {

  //Collection References:
  static final CollectionReference usersCollection = Firestore.instance.collection('users');
  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');

  static Future<int> getBillCount(String userName) async {

    final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: userName).getDocuments();

    final List<DocumentSnapshot> documentList = querySnapshot.documents;

    for(var userDocument in documentList){
      final userDocumentID = userDocument.documentID;
      QuerySnapshot billCollection = await usersCollection.document(userDocumentID).collection('bills').getDocuments();

      if(billCollection == null){
        return 0;
      } else if(billCollection.documents.length == 0){
        return 0;
      }else{
        return billCollection.documents.length;
      }
    }

    return null;

  }


  static Future makeBill() async {

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    final QuerySnapshot querySnapshot = await groceriesCollection.where("roommateList", arrayContains: currentUser.displayName).getDocuments();

    final List<DocumentSnapshot> documents = querySnapshot.documents;

    List roommateList = List();

    for(var doc in documents){
      roommateList = doc.data['roommateList'];
      break;
    }
    
    if(roommateList != null){
      roommateList.forEach((roommateUsername) async {

        final int billNumber = await getBillCount(roommateUsername);
        
        final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: roommateUsername).getDocuments();
        
        final List<DocumentSnapshot> documents = querySnapshot.documents;
        
        String userID;
        
        for(var doc in documents){
          userID = doc.documentID;
          break;
        }
        
        final DocumentReference billDocumentReference = usersCollection
            .document(userID).collection("bills").document("Bill $billNumber");

        final DocumentSnapshot billDocumentSnapshot = await billDocumentReference.get();

        final Map items = billDocumentSnapshot.data;

        for(var item in items.keys){
          print(item.toString());
        }

        final DocumentReference newBillDocumentReference = usersCollection.document(userID).collection("bills").document("Bill ${billNumber + 1}");
        newBillDocumentReference.setData({
          "numItems": 0
        });
      });
    }
  }

  static Future addItemToBill(GroceryItem groceryItem, double cost) async {

    try{

      final List<String> buyerList = groceryItem.buyers.split(",");

      buyerList.forEach((buyerUserName) async {

        try{

          int currentBillNumber = await getBillCount(buyerUserName);


          if(currentBillNumber == 0){
            currentBillNumber = 1;

            final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: buyerUserName).getDocuments();

            final List<DocumentSnapshot> documentList = querySnapshot.documents;

            for(var userDocument in documentList){
              final userDocumentID = userDocument.documentID;
              DocumentReference billDocumentReference = usersCollection.document(userDocumentID).collection('bills').document("Bill $currentBillNumber");

              await billDocumentReference.setData({
                "${groceryItem.itemName}": {
                  "itemCount": groceryItem.itemCount,
                  "itemCost": cost
                },
                "numItems": 1
              });
            }
          }
          else{
            final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: buyerUserName).getDocuments();

            final List<DocumentSnapshot> documentList = querySnapshot.documents;

            for(var userDocument in documentList){
              final userDocumentID = userDocument.documentID;
              DocumentReference billDocumentReference = usersCollection.document(userDocumentID).collection('bills').document("Bill $currentBillNumber");

              await billDocumentReference.updateData({
                "${groceryItem.itemName}": {
                  "itemCount": groceryItem.itemCount,
                  "itemCost": cost
                },
                "numItems": FieldValue.increment(1)
              });
            }
          }

        }
        catch(error){
          print("addItemToBill function (buyerList.foreach) : "+ error.toString());
        }

      });

    }catch(error){
      print("addItemToBill function: "+ error.toString());
    }
  }

}