import 'package:flutter/material.dart';

import '../../Model/CartModel.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(String) onRemove;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Image.network(
          item.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: item.serviceName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' | ${item.brand} | ${item.model}',
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        subtitle: Text('₹${item.serviceCharge}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onRemove(item.serviceId),
        ),
      ),
    );
  }
}