// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart'; // Widgets et interface Flutter
import 'package:http/http.dart' as http; // Pour faire des requêtes HTTP (API)
import 'dart:convert'; // Pour transformer du JSON en objets Dart

// Point d'entrée principal de l'application
void main() {
  runApp(const MyApp()); // Lance l'application avec le widget MyApp
}

// Widget principal de l'application (ne change pas → StatelessWidget)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructeur avec clé optionnelle

  @override
  Widget build(BuildContext context) {
    // MaterialApp = application avec design Material
    return const MaterialApp(
      home: ArticlesPage(), // Page affichée au démarrage
    );
  }
}

// Page qui affiche la liste des articles (elle change → StatefulWidget)
class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

// Classe qui gère l'état de la page Articles
class _ArticlesPageState extends State<ArticlesPage> {
  List articles = []; // Liste vide qui contiendra les articles

  @override
  void initState() {
    super.initState();
    fetchArticles(); // Dès le lancement, on récupère les articles
  }

  // Fonction asynchrone pour récupérer les articles depuis l'API
  Future<void> fetchArticles() async {
    // Envoie une requête GET à l'API Platzi Fake Store
    final response = await http.get(Uri.parse("https://fakeapi.platzi.com/en/products"));

    // Vérifie si la requête a réussi (200 = OK)
    if (response.statusCode == 200) {
      setState(() {
        // Transforme la réponse JSON en liste Dart et met à jour l'état
        articles = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold = structure de base avec AppBar et corps
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")), // Barre en haut avec titre
      body: ListView.builder( // Liste dynamique qui s'adapte au nombre d'articles
        itemCount: articles.length, // Nombre d'éléments dans la liste
        itemBuilder: (context, index) {
          final article = articles[index]; // Récupère l'article à la position index
          return ListTile( // Widget pour afficher une ligne dans la liste
            leading: Image.network(article["images"][0]), // Affiche l'image du produit
            title: Text(article["title"]), // Affiche le titre de l'article
            subtitle: Text("\$${article["price"]}"), // Affiche le prix
            onTap: () { // Action quand on clique sur l'article
              Navigator.push( // Navigation vers une nouvelle page
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetail(article: article), // Passe l'article à la page détail
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Page de détail d'un article
class ArticleDetail extends StatelessWidget {
  final Map article; // L'article reçu en paramètre
  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article["title"])), // Titre = nom de l'article
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Ajoute des marges autour du contenu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne le contenu à gauche
          children: [
            Image.network(article["images"][0]), // Affiche l'image du produit
            const SizedBox(height: 10), // Espace vertical
            Text("Prix : \$${article["price"]}", style: const TextStyle(fontSize: 20)), // Affiche le prix
            const SizedBox(height: 10),
            Text("Description : ${article["description"]}"), // Affiche la description
          ],
        ),
      ),
    );
  }
}
