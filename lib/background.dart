import 'package:flutter/material.dart';

DecorationImage buildBackground(String image) {
  return DecorationImage(
    image: new AssetImage(image),
    fit: BoxFit.cover,
  );
}

