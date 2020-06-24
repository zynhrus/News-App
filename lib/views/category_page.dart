import 'package:flutter/material.dart';
import 'package:newsapp/helper/custom_drawer.dart';
import 'package:newsapp/model/category.dart';
import 'package:newsapp/views/category_detail_page.dart';
import 'package:newsapp/bloc/category_news_bloc_provider.dart';
import 'package:newsapp/views/news_list_page.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      title: 'Category',
      color: Colors.black,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 110,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Wrap(
                  children: List.generate(
                    category.length,
                    (index) => CategoryWidget(
                      title: "#" + category[index]['category'],
                      image: category[index]['image'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return category[index]['category'] == "Headline"
                                  ? NewsListPage()
                                  : CategoryNewsBlocProvide(
                                      child: CategoryDetailPage(
                                          category: category[index]
                                              ['category']),
                                    );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key key, this.title, this.image, this.onTap})
      : super(key: key);

  final String title;
  final String image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 5, bottom: 5),
        width: width / 2 - 10,
        height: height / 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
