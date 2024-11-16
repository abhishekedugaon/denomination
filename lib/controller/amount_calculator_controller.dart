import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

class AmountCalculatorController extends GetxController {
  List<int> amounts = [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1];
  List<TextEditingController> controllers = [];
  RxList<int> results = List<int>.generate(10, (index) => 0).obs;

  RxInt totalAmount = 0.obs;
  RxString totalAmountInWords = ''.obs;

  @override
  void onInit() {
    super.onInit();
    controllers = List.generate(amounts.length, (index) => TextEditingController());


  }

  void calculateTotal() {
    totalAmount.value = 0;
    for (int i = 0; i < amounts.length; i++) {
      int count = int.tryParse(controllers[i].text) ?? 0;
      results[i] = amounts[i] * count;
      totalAmount.value += results[i];

      print('results..$results');
    }
    // totalAmountInWords.value = numberToWords(totalAmount.value);
    totalAmountInWords.value = NumberToWord().convert('en-in', totalAmount.value).toLowerCase();
    if (totalAmountInWords.isNotEmpty) {
      totalAmountInWords.value = '${totalAmountInWords.value[0].toUpperCase()}${totalAmountInWords.value.substring(1)}';
    } else {
      totalAmountInWords.value = 'Zero only/-'; // Handle case when the amount is 0
    }
  }

  // void updateTotalInWords() {
  //   // This method would convert the totalAmount to words, for now, use a placeholder.
  //   // totalAmountInWords.value = numberToWords();
  // }
  //
  // String numberToWords(int number) {
  //   if (number == 0) return '';
  //
  //   final units = [
  //     '',
  //     'One',
  //     'Two',
  //     'Three',
  //     'Four',
  //     'Five',
  //     'Six',
  //     'Seven',
  //     'Eight',
  //     'Nine'
  //   ];
  //   final teens = [
  //     'Ten',
  //     'Eleven',
  //     'Twelve',
  //     'Thirteen',
  //     'Fourteen',
  //     'Fifteen',
  //     'Sixteen',
  //     'Seventeen',
  //     'Eighteen',
  //     'Nineteen'
  //   ];
  //   final tens = [
  //     '',
  //     '',
  //     'Twenty',
  //     'Thirty',
  //     'Forty',
  //     'Fifty',
  //     'Sixty',
  //     'Seventy',
  //     'Eighty',
  //     'Ninety'
  //   ];
  //   final thousands = [
  //     '',
  //     'Thousand',
  //     'Lakh',
  //     'Crore'
  //   ];
  //
  //   String convertHundreds(int n) {
  //     String result = '';
  //     if (n >= 100) {
  //       result += '${units[n ~/ 100]} Hundred';
  //       n %= 100;
  //       if (n > 0) result += ' ';
  //     }
  //     if (n >= 10 && n < 20) {
  //       result += teens[n - 10];
  //     } else if (n >= 20) {
  //       result += tens[n ~/ 10];
  //       n %= 10;
  //       if (n > 0) result += ' ';
  //     }
  //     if (n > 0 && n < 10) {
  //       result += units[n];
  //     }
  //     return result;
  //   }
  //
  //   String result = '';
  //   int thousandCounter = 0;
  //
  //   while (number > 0) {
  //     int chunk;
  //     if (thousandCounter == 1) {
  //       // For "thousands" we take only two digits (for lakh and crore we consider groups of 2 digits)
  //       chunk = number % 100;
  //       number ~/= 100;
  //     } else {
  //       // For hundreds and units, we take three digits
  //       chunk = number % 1000;
  //       number ~/= 1000;
  //     }
  //
  //     if (chunk > 0) {
  //       String chunkInWords = convertHundreds(chunk);
  //       if (thousandCounter > 0) {
  //         chunkInWords += ' ${thousands[thousandCounter]}';
  //       }
  //       result = chunkInWords + (result.isNotEmpty ? ' ' : '') + result;
  //     }
  //     thousandCounter++;
  //   }
  //
  //   return result.trim();
  // }


  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> saveData(String category, String remark) async {
    try {
      var box = Hive.box('dataBox');

      // Get current date and time
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('MMM d, yyyy').format(now);
      String formattedTime = DateFormat('hh:mm a').format(now);

      // Create a map to store category, remark, and other data
      Map entry = {
        'id': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        'category': category,
        'remark': remark,
        'amount': totalAmount.value,
        'amount_to_word': totalAmountInWords.value,
        'date': formattedDate,
        'time': formattedTime,
        'result_amount': results.value??[],
      };

      // Attempt to add the entry to Hive
       box.add(entry);
      print("Data added: $entry");
    } catch (e) {
      // Handle any errors that occur during save
      print("Error saving data: $e");
      // Optionally, you could show a message to the user in case of error
    }
  }

}
