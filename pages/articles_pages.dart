import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ArticlesPage(),
    );
  }
}

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  // Exemple de liste d’articles (normalement récupérés via API)
  List<Map<String, dynamic>> articles = [
    {"id": 1, "title": "Chaussures", "price": 50},
    {"id": 2, "title": "T-shirt", "price": 20},
    {"id": 3, "title": "Casquette", "price": 15},
  ];

  List<int> favoris = []; // Liste des IDs favoris

  @override
  void initState() {
    super.initState();
    chargerFavoris(); // Charger les favoris sauvegardés
  }

  // Charger les favoris depuis SharedPreferences
  Future<void> chargerFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("favoris");
    if (saved != null) {
      setState(() {
        favoris = List<int>.from(json.decode(saved));
      });
    }
  }

  // Sauvegarder les favoris
  Future<void> sauvegarderFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("favoris", json.encode(favoris));
  }

  // Ajouter ou retirer un favori
  void toggleFavori(int id) {
    setState(() {
      if (favoris.contains(id)) {
        favoris.remove(id);
      } else {
        favoris.add(id);
      }
    });
    sauvegarderFavoris();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          final estFavori = favoris.contains(article["id"]);
          return ListTile(
            title: Text(article["title"]),
            subtitle: Text("\$${article["price"]}"),
            trailing: IconButton(
              icon: Icon(
                estFavori ? Icons.favorite : Icons.favorite_border,
                color: estFavori ? Colors.red : null,
              ),
              onPressed: () => toggleFavori(article["id"]),
            ),
          );
        },
      ),
    );
  }
}
