import 'package:carousel_slider/carousel_slider.dart';
import 'package:en3am_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../config/api_urls.dart';
import '../../functions/general_function.dart';
import '../../functions/home_functions.dart';
import '../../models/product.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';
import '../../widget/drawer.dart';
import '../products/product_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activeIndex = 0; // slider active index

  bool isLoading = true;

  List<String> bannersList = [];
  List<Product> latestProducts = [];

  bool viewList = true;
  bool viewGrid = false;

  changeView(String type) {
    if (type == 'grid') {
      viewList = false;
      viewGrid = true;
    } else {
      viewList = true;
      viewGrid = false;
    }
    setState(() {});
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    bannersList = await HomeFunctions.getBanners();

    var allHomeProducts = await HomeFunctions.getHomeProducts();

    latestProducts = List<Product>.from(
        allHomeProducts['latest'].map((x) => Product.fromJson(x)));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    BlocProvider.of<SettingsBloc>(context).add(GetSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(),
        drawer: const InkWellDrawer(),
        bottomNavigationBar: showBottomNavBar(context, 0),
        floatingActionButton: buildFloatingActionBtn(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: isLoading
            ? AssetWidgets.loadingWidget(AppColors.primaryColor)
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الترتيب',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      changeView('grid');
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 35,
                                      color: viewGrid
                                          ? AppColors.primaryColor
                                          : AppColors.gry2,
                                      child: Icon(
                                        Icons.grid_view,
                                        color: viewGrid
                                            ? AppColors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        changeView('list');
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 35,
                                        color: viewList
                                            ? AppColors.primaryColor
                                            : AppColors.gry2,
                                        child: Icon(
                                          Icons.view_list,
                                          color: viewList
                                              ? AppColors.white
                                              : Colors.black,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 0.3,
                        ),

                        //banners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                onPageChanged: (index, reason) =>
                                    setState(() => activeIndex = index),
                                height: MediaQuery.of(context).size.width / 2,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                              items: bannersList
                                  .map((item) => Container(
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Image.network(
                                          ApiUrls.mediaUrl + item,
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20) *
                                              60 /
                                              100,
                                        ),
                                      )))
                                  .toList(),
                            ),
                          ),
                        ),

                        viewGrid
                            ? GridView.count(
                                shrinkWrap: true,
                                primary: false,
                                padding: const EdgeInsets.all(10),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: 0.55,
                                children: <Widget>[
                                  for (int index = 0;
                                      index < latestProducts.length;
                                      index++)
                                    gridBox(latestProducts[index])
                                ],
                              )
                            : const SizedBox(),

                        if (viewList)
                          for (int index = 0;
                              index < latestProducts.length;
                              index++)
                            listBox(latestProducts[index]),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const SizedBox();
                        } else if (state is LoadedState) {
                          return FloatingActionButton(
                            onPressed: () {
                              GeneralFunctions.openUrl('whatsapp://send?phone=966${state.data['whatsapp']['content']}');
                            },
                            backgroundColor: AppColors.primaryColor,
                            child: Image.asset('assets/images/whatsapp.png',),
                          );
                        } else if (state is ErrorState) {
                          return const SizedBox();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ));
  }

  Widget listBox(Product product) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ProductDetails(
                    product: product,
                  )));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.blackColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.blackColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Image.network(
                    ApiUrls.mediaUrl + product.image,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(product.title,
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(
                            product.des,
                            style: const TextStyle(fontSize: 14),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                width: MediaQuery.of(context).size.width / 2.8,
                                padding: EdgeInsets.all(7),
                                child: Center(
                                  child: Text(
                                    'اطلب الآن',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ))
                        ],
                      )))
            ],
          ),
        ));
  }

  Widget gridBox(Product product) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ProductDetails(product: product)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              ApiUrls.mediaUrl + product.image,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2.5,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(product.title,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))),
            const SizedBox(
              height: 12,
            ),
            Center(
                child: Text(
              product.des,
              style: const TextStyle(fontSize: 12),
            )),
            const SizedBox(
              height: 12,
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  width: MediaQuery.of(context).size.width / 2.8,
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      'اطلب الآن',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ))
          ],
        ));
  }
}
