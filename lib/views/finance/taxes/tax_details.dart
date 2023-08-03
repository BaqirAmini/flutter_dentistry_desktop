import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/finance/taxes/tax_info.dart';

class TaxDetails extends StatelessWidget {
  const TaxDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نمبر تشخیصیه مالیه دهنده (TIN)',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('${TaxInfo.TIN}'),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'مالیات سال',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('${TaxInfo.taxOfYear} ه.ش'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'فیصدی مالیات (%)',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('${TaxInfo.taxRate} %'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تاریخ تحویلی',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('${TaxInfo.paidDate}'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'مجموع مالیات',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('${TaxInfo.annTotTaxes.toString()} افغانی'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'مبلع باقی',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('${TaxInfo.dueTaxes} افغانی'),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تحویل مالیات توسط',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('${TaxInfo.firstName} ${TaxInfo.lastName}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
