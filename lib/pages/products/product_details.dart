
import 'package:en3am_app/bloc/cutting/cutting_bloc.dart';
import 'package:en3am_app/bloc/minced/minced_bloc.dart';
import 'package:en3am_app/models/cutting.dart';
import 'package:en3am_app/models/packaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../bloc/packaging/packaging_bloc.dart';
import '../../config/api_urls.dart';
import '../../config/colors.dart';
import '../../controller/CartController.dart';
import '../../functions/general_function.dart';
import '../../models/Size.dart';
import '../../models/product.dart';
import '../../widget/AssetsWidget.dart';
import '../../widget/appbar.dart';
import '../../widget/bottom.dart';
import '../cart/cart_home.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool loading = false;
  bool isDisable = true;

  Sizes? size;
  CuttingModel? cutting;
  PackagingModel? packaging;

  int headId = 1;
  int rumenId = 1;

  //order count
  int count = 1;

  //total price
  int price = 0;

  //minced meat
  int mincedCount = 0;
  int mincedPrice = 0;
  int mincedTotalPrice = 0;

  CartController cartController = CartController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _mincedController = TextEditingController();

  updateOrderCount(String type) {
    if (type == "+") {
      count++;
    } else {
      count--;
    }

    if (count == 0 || count < 0) {
      count = 1;
    }
  }

  updatePrice() {


    if (cutting != null && packaging != null) {
      int cuttingPrice = cutting!.price * count;
      int packagingPrice = packaging!.price * count;
      int sizePrice = size!.price * count;


      mincedCount = int.parse(_mincedController.text);

      mincedTotalPrice = mincedCount * mincedPrice;
      print('$mincedTotalPrice');
      price = cuttingPrice + packagingPrice + sizePrice + mincedTotalPrice;
    }

    if(context.mounted)
      {
        setState(() {

        });
      }
  }

  addToCart({bool goToCart = true}) async {
    setState(() {
      loading = true;
    });

    bool guest = await GeneralFunctions.checkIfGuest();

    if (guest) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('من فضلك قم بتسجيل الدخول'),
          ),
        );

        setState(() {
          loading = false;
        });
      }

      return;
    }

    if (cutting == null || packaging == null) {
      if (context.mounted) {
        AssetWidgets.AlertDia(
            context, 'فشل العملية', 'يرجى اختيار طرق التقطيع والتغليف');
        setState(() {
          loading = false;
        });
      }
      return;
    }


    var result = await cartController.addToCart(
      widget.product.id.toString(),
      count.toString(),
      size!.id.toString(),
      size!.price.toString(),
      cutting!.id.toString(),
      cutting!.price.toString(),
      packaging!.id.toString(),
      packaging!.price.toString(),
      headId.toString(),
      rumenId.toString(),
      price.toString(),
      _noteController.text,
      _mincedController.text,
      mincedTotalPrice.toString(),
    );

    setState(() {
      loading = false;
    });

    if (result['success'] == false) {
      if (context.mounted) {
        AssetWidgets.AlertDia(context, 'فشل العملية', result['data']);
        setState(() {
          loading = false;
        });
      }
      return;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم اضافة المنتج إلى السلة بنجاح'),
          ),
        );

        setState(() {
          loading = false;
        });

        if (goToCart) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const CartHome()));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _mincedController.text = '0';
    for (int i=0;i<widget.product.sizes.length;i++)
      {
        if(widget.product.sizes[i].quantity != 0){
          size = widget.product.sizes[i];
          break;
        }
      }

    if(size == null){
      isDisable = true;
    }else{
      isDisable = false;
    }

    price = widget.product.sizes.first.price;
    BlocProvider.of<CuttingBloc>(context).add(GetCutting());
    BlocProvider.of<PackagingBloc>(context).add(GetPackaging());
    BlocProvider.of<MincedBloc>(context).add(GetMincedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: widget.product.title,
      ),
      floatingActionButton: buildFloatingActionBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: showBottomNavBar(context, 0),
      body: isDisable?empty():
      SingleChildScrollView(
          child: Column(children: <Widget>[
        Image.network(
          ApiUrls.mediaUrl + widget.product.image,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.cover,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.blackColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.title,
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Text(
                    '$price ر.س',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              ListTile(
                leading: Image.asset('assets/images/tamara.png'),
                title: const Text('قسط مع تمارا'),
                subtitle: const Text('قسط على اربع دفعات من تمارا'),
              ),
              const SizedBox(
                height: 15,
              ),
              Text('التفاصيل',
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(
                height: 15,
              ),

              Text(widget.product.des,
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14)),
              const SizedBox(
                height: 15,
              ),

              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  اختر الحجم  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              ResponsiveGridRow(children: [
                for (int index = 0;
                    index < widget.product.sizes.length;
                    index++)
                  ResponsiveGridCol(
                      xs: 6,
                      md: 4,
                      lg: 4,
                      child: ListTile(
                        title: Text(
                          widget.product.sizes[index].quantity != 0?
                          widget.product.sizes[index].title
                              :'${widget.product.sizes[index].title} (غير متوفر)',
                          style: TextStyle(fontSize: widget.product.sizes[index].quantity != 0?14:12,
                          color: widget.product.sizes[index].quantity == 0?Colors.redAccent:Colors.black
                          ),
                        ),
                        leading: Radio<Sizes>(
                          value: widget.product.sizes[index],
                          groupValue: size,

                          onChanged:widget.product.sizes[index].quantity == 0?null: (value) {
                            size = value!;
                            updatePrice();

                            setState(() {});
                          },
                        ),
                      ))
              ]),

              const SizedBox(
                height: 15,
              ),

              // cutting
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  طريقة التقطيع  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              BlocConsumer<CuttingBloc, CuttingState>(
                listener: (context, state) {
                  if (state is LoadedState) {
                    cutting ??= state.data[0];
                    updatePrice();
                  }
                },
                builder: (context, state) {
                  if (state is LoadingState) {
                    return AssetWidgets.loadingWidget(AppColors.primaryColor2);
                  } else if (state is LoadedState) {
                    return ResponsiveGridRow(children: [
                      for (int i = 0; i < state.data.length; i++)
                        ResponsiveGridCol(
                            xs: 6,
                            md: 4,
                            lg: 4,
                            child: Row(
                              children: [
                                Radio<CuttingModel>(
                                  value: state.data[i],
                                  groupValue: cutting,
                                  onChanged: (value) {
                                    cutting = value!;
                                    updatePrice();
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                    child: Text(state.data[i].title,
                                        style: const TextStyle(fontSize: 12))),
                                state.data[i].price == 0
                                    ? Text(
                                        ' (مجاني)',
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        ' ${state.data[i].price} ر.س ',
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            )),
                    ]);
                  } else if (state is ErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              // packaging
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  طريقة التغليف  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              BlocConsumer<PackagingBloc, PackagingState>(
                listener: (context, state) {
                  if (state is LoadedPackagingState) {
                    packaging ??= state.data[0];
                    updatePrice();
                  }
                },
                builder: (context, state) {
                  if (state is LoadingPackagingState) {
                    return AssetWidgets.loadingWidget(AppColors.primaryColor2);
                  } else if (state is LoadedPackagingState) {
                    return ResponsiveGridRow(children: [
                      for (int i = 0; i < state.data.length; i++)
                        ResponsiveGridCol(
                            xs: 6,
                            md: 4,
                            lg: 4,
                            child: Row(
                              children: [
                                Radio<PackagingModel>(
                                  value: state.data[i],
                                  groupValue: packaging,
                                  onChanged: (value) {
                                    packaging = value!;

                                    updatePrice();
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                    child: Text(state.data[i].title,
                                        style: const TextStyle(fontSize: 12))),
                                state.data[i].price == 0
                                    ? Text(
                                        ' (مجاني)',
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        ' ${state.data[i].price} ر.س ',
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            )),
                    ]);
                  } else if (state is ErrorPackagingState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              const SizedBox(
                height: 15,
              ),

              //minced meat
              Row(
                children: [
                  Expanded(
                      child: Divider(
                        color: AppColors.primaryColor,
                      )),
                  Text('  اللحم المفروم  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                        color: AppColors.primaryColor,
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              BlocConsumer<MincedBloc, MincedState>(
                listener: (context, state) {
                  if (state is MincedLoadedState) {
                    mincedPrice = state.data;
                    updatePrice();
                  }
                },
                builder: (context, state) {
                  if (state is MincedLoadingState) {
                    return AssetWidgets.loadingWidget(AppColors.primaryColor2);
                  } else if (state is MincedLoadedState) {
                    return Column(
                      children: [
                        Text('اذا كنت ترغب باللحم المفروم يرجى تحديد الكمية التي ترغب بها (بالكيلوغرام)، سعر الكيلو الواحد ${state.data} ر.س'),
                        const SizedBox(height: 10,),
                        AssetWidgets.textFormWidget(_mincedController, '', const Icon(Icons.info),req: true,number: true,changeFun: updatePrice),
                      ],
                    );
                  } else if (state is MincedErrorState) {
                    return Center(
                      child: InkWell(
                        onTap: (){
                          BlocProvider.of<MincedBloc>(context).add(GetMincedEvent());
                        },
                        child: const Center(child: Text('لم نتمكن من تحميل معلومات اللحم المفروم، انقر للمحاولة مجدداً.'),),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              //head
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  الرأس  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              ResponsiveGridRow(children: [
                ResponsiveGridCol(
                    xs: 6,
                    md: 4,
                    lg: 4,
                    child: ListTile(
                      title: const Text(
                        'سلخ',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: headId,
                        onChanged: (value) {
                          headId = value!;

                          setState(() {});
                        },
                      ),
                    )),
                ResponsiveGridCol(
                    xs: 6,
                    md: 4,
                    lg: 4,
                    child: ListTile(
                      title: const Text(
                        'شلوطة',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: headId,
                        onChanged: (value) {
                          headId = value!;

                          setState(() {});
                        },
                      ),
                    )),
                ResponsiveGridCol(
                    xs: 6,
                    md: 4,
                    lg: 4,
                    child: ListTile(
                      title: const Text(
                        'بدون',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: headId,
                        onChanged: (value) {
                          headId = value!;

                          setState(() {});
                        },
                      ),
                    )),
              ]),

              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  الكرش المصران  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              ResponsiveGridRow(children: [
                ResponsiveGridCol(
                    xs: 6,
                    md: 4,
                    lg: 4,
                    child: ListTile(
                      title: const Text(
                        'نعم',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: rumenId,
                        onChanged: (value) {
                          rumenId = value!;

                          setState(() {});
                        },
                      ),
                    )),
                ResponsiveGridCol(
                    xs: 6,
                    md: 4,
                    lg: 4,
                    child: ListTile(
                      title: const Text(
                        'لا',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: rumenId,
                        onChanged: (value) {
                          rumenId = value!;

                          setState(() {});
                        },
                      ),
                    )),
              ]),

              //notes
              Row(
                children: [
                  Expanded(
                      child: Divider(
                        color: AppColors.primaryColor,
                      )),
                  Text('  الملاحظات',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                        color: AppColors.primaryColor,
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              AssetWidgets.textFormWidget(_noteController, 'في حال كان لديك أية ملاحظات يرجى كتابتها هنا', const Icon(FontAwesomeIcons.noteSticky),multiRows: true),

              //quantity
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                  Text('  العدد  ',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Expanded(
                      child: Divider(
                    color: AppColors.primaryColor,
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //increase or decrease quantity
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey,width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              updateOrderCount('-');
                              updatePrice();
                              setState(() {});
                            },
                            child: const Icon(FontAwesomeIcons.circleMinus),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              updateOrderCount('+');
                              updatePrice();
                              setState(() {});
                            },
                            child: const Icon(FontAwesomeIcons.circlePlus),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => addToCart(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                        child: loading
                            ? AssetWidgets.loadingWidget(AppColors.white)
                            : Text(
                                'شراء الآن $price ر.س',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                  ),
                ),
                InkWell(
                    onTap: () => addToCart(goToCart: false),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 45,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: AppColors.white,
                      ),
                      child: Center(
                          child: Icon(
                        FontAwesomeIcons.cartShopping,
                        color: AppColors.primaryColor,
                      )),
                    )),
              ],
            )),
        const SizedBox(
          height: 30,
        ),
      ])),
    );
  }

  Widget empty(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/sheep.jpg',
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.width/2,
          ),
          const SizedBox(height: 10,),
          const Text('هذا الصنف غير متوفر حالياً',style: TextStyle(fontWeight: FontWeight.bold),),

        ],
      ),
    );
  }
}
