import 'package:apotek_fe/models/obat.dart';
import 'package:apotek_fe/ui/authpage/register/screen/body.dart';
import 'package:apotek_fe/ui/search/search_page.dart';
import 'package:apotek_fe/ui/home/widgets/home_bottom_bar.dart';
import 'package:apotek_fe/ui/home/widgets/items_widget.dart';
import 'package:apotek_fe/utils/api-service/get_obat.dart';
import 'package:apotek_fe/utils/blade/carousel.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function()? onObatUpdated;
  const HomeScreen({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.onObatUpdated,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CarouselController _carouselController = CarouselController();
  int _current = 0;
  List<Obat> obats = [];
  bool _isLoading = true;
  String _userId = '';

  final List<String> imgList = [
    'slide 1.png',
    'slide 2.png',
    'slide 3.png',
    'slide 4.png'
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    fetchObats();
  }

  void onObatUpdated() {
    setState(() {
      _isLoading = true;
    });
    fetchObats().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> fetchObats() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await getObats();
      setState(() {
        obats = (result as List).map((item) => Obat.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching obats: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data obat')),
      );
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _current = index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Find Your Drugs . . .',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : obats.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada Obat',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: fetchObats,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                CarouselWithIndicator(
                                  imgList: imgList,
                                  carouselController: _carouselController,
                                  current: _current,
                                  onPageChanged: _onPageChanged,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      imgList.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => _carouselController
                                          .animateToPage(entry.key),
                                      child: Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: TabBar(
                                controller: _tabController,
                                labelColor: const Color(0xFFE57734),
                                unselectedLabelColor:
                                    Colors.black.withOpacity(0.5),
                                isScrollable: true,
                                indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: Color(0xFFE57734),
                                  ),
                                  insets: EdgeInsets.symmetric(horizontal: 16),
                                ),
                                labelStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                tabs: const [
                                  Tab(text: "Pilek"),
                                  Tab(text: "Batuk"),
                                  Tab(text: "Panas"),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height +
                                500, // Atur tinggi sesuai kebutuhan
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                ItemsWidget(
                                  obats: obats
                                      .where((obat) =>
                                          obat.category == 'Obat Pilek')
                                      .toList(),
                                  onObatUpdated: onObatUpdated,
                                  scrollable: false,
                                ),
                                ItemsWidget(
                                  obats: obats
                                      .where((obat) =>
                                          obat.category == 'Obat Batuk')
                                      .toList(),
                                  onObatUpdated: onObatUpdated,
                                  scrollable: false,
                                ),
                                ItemsWidget(
                                  obats: obats
                                      .where((obat) =>
                                          obat.category == 'Obat Panas')
                                      .toList(),
                                  onObatUpdated: onObatUpdated,
                                  scrollable: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: NavbarPage(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }
}
