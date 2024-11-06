import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 57, 52, 56)),
      home: ItemsData(),
      
    );
  }
}

class ItemsData extends StatelessWidget {
  ItemsData({Key? key}) : super(key: key);

  // Sample data
  final List<Product> products = [
    Product(
        name: "Hertarium",
        description:
            "The cryptocurrency circulating internally in the Herta Space Station.",
        rarity: "Epic",
        image: "Hertareum.webp"),
    Product(
        name: "Undying Starlight",
        description:
            "Splendid gems formed when a shooting star fell from the sky.",
        rarity: "Exotic",
        image: "star.png"),
    Product(
        name: "Trash",
        description: "Worthless trash Better carry some with you.",
        rarity: "Common",
        image: "Trash.webp"),
    Product(
        name: "Lifeless Blade",
        description: "Legendary Sword",
        rarity: "Exotic",
        image: "sword.webp"),
    Product(
        name: "Self-Modeling Resin",
        description: "Rare material used to custom-make Relics.",
        rarity: "Exotic",
        image: "Self-Modeling_Resin.webp"),
    Product(
        name: "A tuskpir wrap bought for Bailu",
        description:
            "A cake roll that is too cute to eat. Name from the beautiful texture",
        rarity: "Rare",
        image: "Item_Tuskpir_Wrap.webp"),
    Product(
        name: "If i can stop one heart from breaking",
        description: "A record that can be played on the Express' phonograph.",
        rarity: "Rare",
        image: "Item_Phonograph_Record.jpg"),
    Product(
        name: "Express Supply Pass",
        description:
            "Provisions prepared by the Express for Trailblazers. Claim with pass.",
        rarity: "Epic",
        image: "Daily_Express_Supply_Pass.webp"),
    Product(
        name: "Trailblaze Power",
        description:
            "The Imaginary power residing in the engines of the Astral Express",
        rarity: "Epic",
        image: "Item_Trailblaze_Power.webp"),
    Product(
        name: "Allseer",
        description:
            "Digital stickers that can be used to decorate the pages of the Dreamtour Handbook.",
        rarity: "Epic",
        image: "Dreamscape_Pass_Sticker_Allseer.webp"),
    Product(
        name: "Ancient Coin",
        description:
            "An old coin from a time when metal was still a plentiful resource in Belobog.",
        rarity: "Rare",
        image: "Item_Ancient_Coin.webp"),
    Product(
        name: "Auspicious XV",
        description:
            "A new generation flagship jade abacus, its off-white material feels exquisite to the touch.",
        rarity: "Rare",
        image: "Item_Auspicious_XV.webp"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
        backgroundColor: const Color.fromARGB(255, 197, 198, 202),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(products: products),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the item information page and pass the selected product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ItemInformationPage(product: products[index]),
                ),
              );
            },
            child: ProductBox(
              name: products[index].name,
              description: products[index].description,
              rarity: products[index].rarity,
              image: products[index].image,
            ),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Product> products;

  MySearchDelegate({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return buildResultListView(matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return buildResultListView(matchQuery);
  }

  Widget buildResultListView(List<Product> matchQuery) {
    return Container(
      color: const Color.fromARGB(255, 57, 52, 56), 
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result.name,
              style: const TextStyle(
                  color: Colors.white), // Change text color to white
            ),
            onTap: () {
              // Navigate to the item information page and pass the selected product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemInformationPage(product: result),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class ProductBox extends StatelessWidget {
  const ProductBox(
      {Key? key,
      required this.name,
      required this.description,
      required this.rarity,
      required this.image})
      : super(key: key);
  final String name;
  final String description;
  final String rarity;
  final String image;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    // Assign background color based on rarity
    switch (rarity.toLowerCase()) {
      case "common":
        backgroundColor = Colors.grey;
        break;
      case "uncommon":
        backgroundColor = Colors.green;
        break;
      case "exotic":
        backgroundColor = const Color.fromARGB(255, 216, 188, 61);
        break;
      case "rare":
        backgroundColor = Colors.blue;
        break;
      case "epic":
        backgroundColor = Colors.purple;
        break;
      default:
        backgroundColor = Colors.white;
    }

    // Reduce the description text
    final truncatedDescription = description.length > 50
        ? '${description.substring(0, 30)}...'
        : description;

    return Container(
      padding: const EdgeInsets.all(2),
      height: 120,
      color: const Color.fromARGB(255, 57, 52, 56),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/images/${image}"),
            Expanded(
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(truncatedDescription,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2), // Change text color to white
                    Text("Rarity: $rarity",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemInformationPage extends StatelessWidget {
  final Product product;

  const ItemInformationPage({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      backgroundColor: const Color.fromARGB(255, 57, 52, 56),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Add border radius if desired
              child: Image.asset("assets/images/${product.image}"),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Change box cover color here if needed
                borderRadius:
                    BorderRadius.circular(10), // Add border radius if desired
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description \n ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black)), // Change text color to black
                  const SizedBox(height: 8),
                  Text(" ${product.description} \n",
                      style: const TextStyle(color: Colors.black)),
                  Text("Rarity\n ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black)), // Change text color to black
                  Text(" ${product.rarity}",
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final String rarity;
  final String image;

  Product(
      {required this.name,
      required this.description,
      required this.rarity,
      required this.image});
}
