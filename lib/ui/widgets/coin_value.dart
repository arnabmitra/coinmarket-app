import 'package:coinbase_sockets/models/coinbase_response.dart';
import 'package:coinbase_sockets/providers/coinbase_provider.dart';
import 'package:flutter/material.dart';

/// Coin Value
///
/// Shows the coin value for ETH and BTC when sockets are
/// open
class CoinValue extends StatefulWidget {
  final CoinbaseProvider provider;

  const CoinValue({
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  State<CoinValue> createState() => _CoinValueState();
}


class _CoinValueState extends State<CoinValue> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
           CoinPrice(
            color: Colors.blue,
            stream: widget.provider.ethStream,
          ),
           CoinPrice(
            color: Colors.orange,
            stream: widget.provider.bitcoinStream,
          ),
      ],
    );
  }
}



class CoinPrice extends StatelessWidget {
  final Stream<CoinbaseResponse> stream;
  final Color color;

  CoinPrice({
    required this.stream,
    required this.color,
    Key? key,
  }) : super(key: key);

  final List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoinbaseResponse>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            items.add('${snapshot.data!.productId}: ${snapshot.data!.price}');

            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                itemExtent: 20,
                itemBuilder: (context, index) {
                  print(items[index].toString());
                  return ListTile(
                      title: Text(items[index].toString())
                  );
                });
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Text('No more data'),
            );
          }

          return const Center(
            child: Text('No data'),
          );
        },
      );
  }


}
