import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'amount_calculator_controller.dart';
import 'history_amount.dart'; // Import controller

class AmountCalculatorPage extends StatefulWidget {
  const AmountCalculatorPage({Key? key}) : super(key: key);

  @override
  _AmountCalculatorPageState createState() => _AmountCalculatorPageState();
}

class _AmountCalculatorPageState extends State<AmountCalculatorPage> {
  final controller = Get.put(AmountCalculatorController());
  String? selectedCategory = 'General'; // Default dropdown value
  TextEditingController remarkController = TextEditingController();

  void _showMenu(BuildContext context) async {
    await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000.0, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem<String>(
          value: 'history',
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.lightBlueAccent, // Icon color
                size: 20, // Smaller icon size to reduce spacing
              ),
              SizedBox(width: 4), // Reduced spacing between icon and text
              Text(
                'History',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 14, // Font size to reduce overall size
                ),
              ),
            ],
          ),
        ),
        // Additional menu items if needed
      ],
      elevation: 8.0,
      color: Color(0xFF1E2A38), // Background color for the popup menu
    ).then((value) {
      if (value == 'history') {
        print('History selected');
       Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(),));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;


    return Scaffold(
      backgroundColor: Colors.black,
   /*   body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150, // Set a fixed height for the background image
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/currency_banner.jpg'), // Path to your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      _showMenu(context); // Trigger the menu when clicked
                    }, icon: Icon(Icons.more_vert,color: Colors.white,))
                  ],
                ),
                controller.totalAmount.value!=0
                ?Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Obx(() {
                        print('controller.totalAmount.value..${controller.totalAmount.value}');
                        return Text(
                        '₹ ${controller.totalAmount.value}',
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                      );
                      }),
                      const SizedBox(height: 8),
                      Obx(() {
                        return controller.totalAmountInWords.value.isNotEmpty
                         ? Text(
                        '${controller.totalAmountInWords.value} Only/-',
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      )
                        :const Text('',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        );
                      }),
                    ],
                  ),
                )
                :const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Denomination',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: controller.amounts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '₹ ${controller.amounts[index]} x',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 20,),

                          SizedBox(
                            height: 45,
                            width:100,
                            child: TextField(
                              controller: controller.controllers[index],
                              keyboardType: TextInputType.number,

                              onChanged: (value) {
                                controller.calculateTotal();
                                // print(controller.results.value[index] > 0);
                                // print(controller.results.value[index]);
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  filled: true,
                                  // fillColor: Colors.white,
                                  suffixIcon: Obx((){
                                    return  Visibility(
                                      visible:controller.results.value[index] > 0 ,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            controller.controllers[index].clear();
                                            controller.results.value.removeAt(index);
                                            controller.results.value.insert(index, 0);
                                            controller.calculateTotal();
                                           // print('results22.${controller.results.value}');
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 13, // Reduced icon size
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  suffixIconConstraints: BoxConstraints(
                                    minWidth: 20, // Minimum width of the icon container
                                    minHeight: 15, // Minimum height of the icon container
                                  ),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey,width: 0.5), // Default grey border
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue, width:0.5), // Blue border when focused, with thickness of 2
                                  ),
                                  contentPadding: EdgeInsets.all(2)
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onEditingComplete: () {
                                // Move focus to the next TextField
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                          ),
                        Obx(() {
                          print('heloo..');
                          print(controller.results.value);
                          int length = controller.results.value[index].toString().length;
                          double fontSize;

                          if (length < 10) {
                            fontSize = 20;
                          }
                          else if (length == 10) {
                            fontSize = 17;
                          } else if (length > 10) {
                            fontSize = 13;
                          }
                          else {
                            fontSize = 10;
                          }

                          return controller.results.value[index].toString().length > 15
                         ?  Expanded(
                           child: Text(
                              ' = ₹ ${controller.results.value[index]}',
                              style: TextStyle(color: Colors.white, fontSize: fontSize),
                            ),
                         )
                          :Text(
                            ' = ₹ ${controller.results.value[index]}',
                            style: TextStyle(color: Colors.white, fontSize: fontSize),
                          );
                        })

                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),*/
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with the Total Amount information
          SliverAppBar(
            pinned: true,
            expandedHeight: screenHeight/5.5,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                   _showMenu(context);
                  },
                ),
              ],
            //backgroundColor: Colors.blueAccent,
            flexibleSpace: Obx((){
              return  FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/currency_banner.jpg', // Replace with your image path
                  fit: BoxFit.cover,       // Ensures the image covers the space
                ),
                titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: controller.totalAmount.value != 0
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 15 * textScale,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FittedBox(
                      child:Text(
                        '₹ ${controller.totalAmount.value}',
                        style:  TextStyle(fontSize: 20 * textScale, color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    ),
                     controller.totalAmountInWords.value.isNotEmpty
                          ? Text(
                        '${controller.totalAmountInWords.value} Only/-',
                        style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10 * textScale,),
                      )
                          :const Text('',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      )
                  ],
                )
                    :const Text('Denomination',style: TextStyle(color: Colors.white),),
              );
            })

          ),

          SliverToBoxAdapter(
            child: SizedBox(height: screenHeight/50),
          ),
          // Denominations list
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                final num = controller.amounts[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.005,
                    horizontal: screenWidth * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth/5,
                        child:  Text(
                          '₹ $num x',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SizedBox(width: screenWidth/50),
                      SizedBox(
                        width: screenWidth/3.5,
                        child: TextField(
                          controller: controller.controllers[index],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            controller.calculateTotal();
                          },
                          style: const TextStyle(color: Colors.white), // White text for contrast
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade900, // Black background for the TextField
                            suffixIcon: Obx(() {
                              return Visibility(
                                visible: controller.results.value[index] > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 7),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white, // White background for the icon container
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      controller.controllers[index].clear();
                                      controller.results.value.removeAt(index);
                                      controller.results.value.insert(index, 0);
                                      controller.calculateTotal();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.black, // Black icon for contrast with the white container
                                      size: 13, // Reduced icon size
                                    ),
                                  ),
                                ),
                              );
                            }),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 20, // Minimum width of the icon container
                              minHeight: 15, // Minimum height of the icon container
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default grey border
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 0.5), // Blue border when focused
                            ),
                            contentPadding: const EdgeInsets.all(2),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),

                      ),
                      SizedBox(width: screenWidth/30),
                      Obx(() {
                        print('heloo..');
                        print(controller.results.value);
                        int length = controller.results.value[index].toString().length;
                        double fontSize;

                        if (length < 10) {
                          fontSize = 20;
                        }
                        else if (length == 10) {
                          fontSize = 17;
                        } else if (length > 10) {
                          fontSize = 13;
                        }
                        else {
                          fontSize = 10;
                        }
                        return controller.results.value[index].toString().length > 15
                            ?  Expanded(
                          child: Text(
                            ' = ₹ ${controller.results.value[index]}',
                            style: TextStyle(color: Colors.white, fontSize: fontSize),
                          ),
                        )
                            :Text(
                          ' = ₹ ${controller.results.value[index]}',
                          style: TextStyle(color: Colors.white, fontSize: fontSize),
                        );
                      })
                    ],
                  ),
                );
              },
                childCount: controller.amounts.length
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: screenHeight /30),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.flash_on, // main FAB icon
        activeIcon: Icons.close, // icon when FAB is open
        backgroundColor: Colors.blue, // main FAB color
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10, // space between FAB options
        spaceBetweenChildren: 8, // space between options and main FAB
        children: [
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            label: 'Clear',
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            onTap: () {
               controller.results = List<int>.generate(10, (index) => 0).obs;
              // controller.results.clear();
              controller.controllers.map((e) => e.clear()).toList();
              //controller.controllers=List.generate(controller.amounts.length, (index) => TextEditingController());
              controller.calculateTotal();
              setState(() {});
              // Implement your clear functionality here
              print('Clear button pressed');

              print('after refresh..${controller.results}');
              print(controller.controllers);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.file_download_outlined),
            label: 'Save',
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            onTap: () {
              showSaveDialog();
              // getData();
              // Implement your save functionality here
              print('Save button pressed');
            },
          ),
        ],
      ),
    );
  }


  void showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: EdgeInsets.all(0),
          title: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red,size: 30,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: Colors.grey[800],
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,width: 0.5), // Default grey border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width:0.5), // Blue border when focused, with thickness of 2
                  ),
                ),
                items: ['General', 'Income', 'Expense']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
             const SizedBox(height: 16),
              TextField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Fill your remark (if any)',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey.shade900, // Black background for the TextField
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5), // Default grey border
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 0.5), // Blue border when focused
                  ),
                ),
                style: const TextStyle(color: Colors.white), // White text for contrast
              ),

            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 Text(
                                  'Confirmation',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                  child:const Text(
                                    'NO',
                                    style: TextStyle(color: Colors.white,fontSize: 13),
                                  ),
                                ),
                                 const SizedBox(width: 5,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  onPressed: () {
                                    // Save data and close dialogs
                                    String category = selectedCategory!;
                                    String remark = remarkController.text;
                                    controller.saveData(category, remark);
                                    Navigator.of(context).pop(); // Close confirmation dialog
                                    Navigator.of(context).pop(); // Close main dialog
                                    FocusScope.of(context).unfocus();
                                    remarkController.clear();
                                    selectedCategory = 'General';
                                    controller.results = List<int>.generate(10, (index) => 0).obs;
                                    // controller.results.clear();
                                    controller.controllers.map((e) => e.clear()).toList();
                                    //controller.controllers=List.generate(controller.amounts.length, (index) => TextEditingController());
                                    controller.calculateTotal();
                                    setState(() {

                                    });
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white,fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Text('Save', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }
}
