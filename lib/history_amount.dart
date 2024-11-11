import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share/share.dart';

class HistoryPage extends StatelessWidget {
   HistoryPage({super.key});
  var box = Hive.box('dataBox');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.65),
        title: const Text('History', style: TextStyle(fontSize: 20)),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No history found',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            );
          }
          print('item..$box');
          // Convert box items to a List and sort by id in descending order
          List<Map<dynamic, dynamic>> items = box.values.cast<Map<dynamic, dynamic>>().toList();
          items.sort((a, b) => (int.parse(b['id']??"0")).compareTo(int.parse(a['id']??"0"))); // Sort by 'id' in descending order

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              // var entry = box.getAt(index);
              var entry =  items[index];
              return Slidable(
                key: Key(entry["amount"].toString()),
                direction: Axis.horizontal,
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                         onDelete(entry['id'].toString());
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        // Add edit action if needed
                        print('Edit button pressed');
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        onShare(entry);
                        // Add share action if needed
                        print('Share button pressed');
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['category']??"",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹ ${entry['amount'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(color: Colors.blue[200], fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              entry['remark'] ?? '',
                              style: TextStyle(color: Colors.grey[400], fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              entry['date']??"",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              entry['time']??"",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.red,
            width: 80,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white),
                Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            width: 80,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: Colors.white),
                Text('Edit', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(
            color: Colors.green,
            width: 80,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, color: Colors.white),
                Text('Share', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void onDelete(String id) {
    // Find the key corresponding to the entry with the specified ID
    final keyToDelete = box.keys.firstWhere((key) => box.get(key)['id'] == id,
      orElse: () => null, // Return null if not found
    );

    if (keyToDelete != null) {
      box.delete(keyToDelete);
    }
  }
  void onShare(entry) {


    print('toshare..');
    print(entry.runtimeType);
    print(entry);
    // Share.share('abcasjkasjkd');
    Share.share(generateDenominationMessage(entry));
  }

   String generateDenominationMessage(entry) {

    List getDeatils = entry['result_amount']??[];
    int twoThousand_count = getDeatils[0] != 0 ?getDeatils[0]~/2000:0;
    int fiveHundred_count = getDeatils[1] != 0 ?getDeatils[1]~/500:0;
    int twohundred_count = getDeatils[2] != 0 ?getDeatils[2]~/200:0;
    int onehundred_count = getDeatils[3] != 0 ?getDeatils[3]~/100:0;
    int fifty_count = getDeatils[4] != 0 ?getDeatils[4]~/50:0;
    int twenty_count = getDeatils[5] != 0 ?getDeatils[5]~/20:0;
    int ten_count =getDeatils[6] != 0 ?getDeatils[6]~/10:0;
    int five_count = getDeatils[7] != 0 ?getDeatils[7]~/5:0;
    int two_count = getDeatils[8] != 0 ?getDeatils[8]~/2:0;
    int one_count =getDeatils[9] != 0 ?getDeatils[9]~/1:0;
     return '''
              Denomination
              ${entry['category']} Denomination
              ${entry['date']} ${entry['time']}
              ${entry['remark']}
              --------------------------------
              Rupee x Counts = Total
              ₹ 2,000 x $twoThousand_count = ₹ ${getDeatils[0]}
              ₹ 500  x $fiveHundred_count = ₹ ${getDeatils[1]}
              ₹ 200  x $twohundred_count = ₹ ${getDeatils[2]}
              ₹ 100  x $onehundred_count = ₹ ${getDeatils[3]}
              ₹ 50   x $fifty_count = ₹ ${getDeatils[4]}
              ₹ 20   x $twenty_count = ₹ ${getDeatils[5]}
              ₹ 10   x $ten_count = ₹ ${getDeatils[6]}
              ₹ 5    x $five_count = ₹ ${getDeatils[7]}
              ₹ 2    x $two_count = ₹ ${getDeatils[8]}
              ₹ 1    x $one_count = ₹ ${getDeatils[9]}
              --------------------------------
              Total Counts: ${twoThousand_count+fiveHundred_count+twohundred_count+onehundred_count+fifty_count+twenty_count+ten_count+five_count+two_count+one_count}
              Grand Total Amount:
              ₹ ${entry['amount']}
              ${entry['amount_to_word']??""} only/-
              ''';
   }

}

