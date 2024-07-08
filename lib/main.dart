import 'package:Boycott/button.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' show parse;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
  ));
  runApp(MaterialApp(
    home: Home(cameras: cameras),
  ));
}

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Home({required this.cameras, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  String barcodeResult = '';
  String barcodeResult2 = '';
  String status = '';

  List<String> brands = [
    '7up',
    'pepsi',
    'pepsico'
        'Acqua Panna',
    'Actimel',
    'Activia',
    'Adidas',
    'Aerin',
    'Aero',
    'Aesop',
    'Agoda',
    'Ahava',
    'Airbnb',
    'Airwaves',
    'Aldi Nord',
    'Alpro',
    'Always',
    'Amazon',
    'Ambipur',
    'American Eagle',
    'Amika',
    'Appletiser',
    'Aptamil',
    'Aquafina',
    'Aquarius',
    'Aramis',
    'Ariel',
    'Arwa',
    'Aussie',
    'Aviva',
    'AXA',
    'Axe',
    'BAE Systems',
    'Bally',
    'Bank of America',
    'Bank of Montreal',
    'Barbican',
    'Barclays',
    'Bath & Body Works',
    'Bayer Pharmaceuticals',
    'Belvita',
    'Ben & Jerry\'s',
    'Ben\'s Originals',
    'Benefit Cosmetics',
    'Berskha',
    'BIOTHERM',
    'BNP Paribas',
    'BNY Mellon',
    'Bobbi Brown',
    'Body Armor',
    'Boeing',
    'Bold',
    'Bomaja',
    'Bon Aqua',
    'Booking.com',
    'Bounty',
    'Bounty Paper Towels',
    'BP',
    'British Petroleum',
    'Braun',
    'Bulgari',
    ' Bvlgari',
    'Burger King',
    'Buxton',
    'Cadbury',
    'Capital One',
    'Caribou Coffee',
    'Carmel Agrexco',
    'Carnation',
    'Carrefour',
    'Carte D\'Or Ice Creams',
    'Caterpillar',
    'Catsan',
    'Celebrations',
    'Celine',
    'Cerave',
    'Chanel',
    'Charmin',
    'Cheapflights',
    'Cheerios',
    'Cheetos',
    'Cif',
    'Clear Blue',
    'Clinique',
    'Coca-Cola',
    'Coca Cola',
    'Coke'
        'Coffee Mate',
    'Comfort',
    'Conservative party',
    'Cornetto Ice Creams',
    'Costa Coffee',
    'Coty',
    'Cow & Gate',
    'Crest Toothpaste',
    'Curver',
    'Daim',
    'Dairy Milk',
    'Danone',
    'Dasani Water',
    'Delilah',
    'Dell',
    'Aquafina'
        'Desert Diamond',
    'Diesel Frangrances',
    'Diet Coke',
    'DKNY',
    'Dine',
    'Dior / Christian Dior',
    'Dior',
    'Christian Dior',
    'Disney',
    'Dogadan',
    'Dolce Gusto',
    'Dolmio',
    'Domestos',
    'Doritos',
    'Dove',
    'Dr Pepper',
    'Eden Springs',
    'Elbit Systems',
    'Enjoy Life',
    'Espresso House',
    'Estee Lauder',
    'Evian',
    'Express VPN',
    'Facebook',
    'Fairlife',
    'Fairy',
    'Fanta',
    'Febreze',
    'Felix',
    'Fendi',
    'Fenty Beauty by Rihanna',
    'Ferrero',
    'Ferrero Rocher',
    'Fiverr',
    'Flash',
    'Fuzetea',
    'G4S',
    'Game Fuel',
    'Garnier',
    'Gatorade',
    'Gillette',
    'Giorgio Armani Beauty',
    'Givenchy',
    'Glaceau Smartwater',
    'Google',
    'Grenade',
    'Hadiklaim',
    'Halls',
    'Head and Shoulders',
    'Hellman\'s',
    'Herbal Essences',
    'Hotel Chocolat',
    'HP',
    'HSBC',
    'Hubba Bubba',
    'Hublot',
    'Hyundai',
    'IAMS',
    'Il Makiage',
    'Indigo Books',
    'Innocent Smoothies',
    'Instagram',
    'Intel',
    'IT Cosmetics',
    'Jaguar',
    'Jo Malone',
    'Juicy Fruit',
    'Kayak',
    'Kenzo',
    'Kerastase',
    'Keter',
    'KFC',
    'Kiehl\'s',
    'Kilian',
    'Kinder',
    'King Solomon',
    'KitKat',
    'Knorr',
    'Krispy Kreme',
    'KurKure',
    'Kylie Cosmetics',
    'La Mer',
    'La Roche-Posay',
    'Lab Series',
    'Labour party',
    'Lancome',
    'Land Rover',
    'Range Rover'
        'Lavazza',
    'Lay\'s',
    'Legal & General',
    'Lenor',
    'Lidl',
    'Lion',
    'Lipton',
    'Lipton Iced Tea',
    'Lloyds Bank',
    'Lockheed Martin',
    'Loewe',
    'Loreal',
    'L\'oreal'
        'Louis Vuitton',
    'Lux',
    'LVMH',
    'Lynx',
    'M&M\'s',
    'MAC Cosmetics',
    'MBDA',
    'Magen David Adom',
    'Maggi',
    'Magnum Ice Creams',
    'Walls'
        'Maison Francis Kurkdjian',
    'Maison Margiela Fragrances',
    'Malteasers',
    'Marc Jacobs',
    'Marks and Spencer',
    'M&S',
    'Mars',
    'Maybelline',
    'McDonalds',
    'Mercedes Benz',
    'Meta',
    'Microsoft',
    'Mikado',
    'Milka',
    'Milky Way',
    'Milkybar',
    'Minute Maid',
    'Mirinda',
    'Monday.com',
    'Mondelez',
    'Monster Energy',
    'Moovit',
    'MoroccanOil',
    'Motorola',
    'Mountain Dew',
    'Movenpick',
    'Mugler Beauty',
    'Nescafe',
    'Nespresso',
    'Nesquik',
    'Nestle',
    'Next',
    'NIOD',
    'Noon.com',
    'Nutella',
    'Nvidia',
    'NYX Professional Makeup',
    'Oasis',
    'Olay',
    'Old Spice',
    'OpenAI',
    'Opentable',
    'Oracle',
    'Oral B',
    'Orangina',
    'Oreo',
    'Origins',
    'Outbrain',
    'Pampers',
    'Pantene',
    'Papa Johns',
    'Paramount',
    'Payoneer',
    'Pedigree',
    'Peet\'s Coffee',
    'Pepsi',
    'Perrier',
    'Persil',
    'Philadelphia',
    'Piers Morgan',
    'Pizza Hut',
    'Popeyes',
    'Power Action',
    'Powerade',
    'Prada Beauty',
    'Pret-a-manger',
    'Priceline',
    'Procter & Gamble',
    'Puma',
    'Pure Life',
    'Purina',
    'Quaker Oats',
    'Quality Street',
    'Ralph Lauren Frangrances',
    'Rani',
    'Rapunzel',
    'Rapyd',
    'Rare Beauty by Selena Gomez',
    'Raytheon',
    'RBS',
    'Rentalcars.com',
    'Rexona',
    'Ritz',
    'River Island',
    'Rockstar Energy',
    'Royal Canin',
    'S.Pellegrino',
    'Sabra',
    'Sadaf Foods',
    'Sadia Foods',
    'SAP',
    'Schweppes',
    'Schweppes',
    'Scotia Bank',
    'Sephora',
    'Seven Seas',
    'Shake Shack',
    'STELLA by Stella McCartney',
    'eToro',
    'Shams',
    'Shredded Wheat',
    'Shreddies',
    'Siemens',
    'Simply Beverages',
    'Skechers',
    'Skims',
    'Skittles',
    'Smarties',
    'Smartwater',
    'Snickers',
    'SodaStream',
    'Sour Patch Kids',
    'Sprite',
    'Spyglass Media Group',
    'Standard Life',
    'Starbucks',
    'Sudocrem',
    'Surf',
    'Taboola',
    'Taco Bell',
    'TAG Heuer',
    'Tampax',
    'Tang',
    'Ted Baker',
    'Temptations',
    'Tesco',
    'Teva Pharmaceuticals',
    'The Ordinary',
    'Tic Tac',
    'Tide',
    'Tiffany & Co.',
    'Tim Hortons',
    'Toblerone',
    'Tom Ford Beauty',
    'Too Faced',
    'Tory Burch',
    'Tresemme',
    'Tropicana',
    'Twix',
    'Unicef',
    'Unilever',
    'Urban Decay',
    'Valentino Beauty',
    'Venus',
    'Viber',
    'Vicks',
    'Victorias Secret',
    'Viktor & Rolf Beauty',
    'Visa',
    'Vitaminwater',
    'Vittel',
    'Volvic',
    'Volvo Heavy Machinery',
    'Walkers',
    'Walls Ice Creams',
    'Walmart',
    'Waze',
    'Wells Fargo',
    'Whiskas',
    'Wix',
    'Wrigley\'s Extra',
    'Yum Foods',
    'Yves Saint Laurent Beauty',
    'YSL Beauty',
    'Zara',
  ];

  Future<void> check(String prod, String man) async {
    bool boycotted = false;

    for (int i = 0; i < brands.length; i++) {
      if (prod.toLowerCase().contains(brands[i].toLowerCase())) {
        setState(() {
          status = 'Boycott';
        });
        boycotted = true;
        break;
      }
    }

    if (!boycotted) {
      for (int i = 0; i < brands.length; i++) {
        if (man.toLowerCase().contains(brands[i].toLowerCase())) {
          setState(() {
            status = 'Boycott';
          });
          boycotted = true;
          break;
        }
      }
    }

    if (!boycotted) {
      if (prod != 'Product not found') {
        setState(() {
          status = 'Not boycotted';
        });
      } else {
        setState(() {
          status = 'Not Sure';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> scanBarcode() async {
    try {
      var options = const ScanOptions(
        strings: {
          'cancel': 'Cancel',
          'flash_on': '',
          'flash_off': '',
        },
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0.5,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      if (result.rawContent.isNotEmpty) {
        lookupBarcode(result.rawContent);
      } else {
        print('Scan cancelled or failed');
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  Future<void> lookupBarcode(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        final product = data['product'];
        setState(() {
          barcodeResult = '${product['product_name'] ?? 'Not found'}';
          barcodeResult2 = '${product['brands'] ?? 'Not found'}';
          check(barcodeResult, barcodeResult2);
        });
      } else {
        setState(() {
          barcodeResult = 'Product not found';
          barcodeResult2 = 'Product not found';
          check(barcodeResult, barcodeResult2);
        });
      }
    } else {
      setState(() {
        barcodeResult = 'Failed to load barcode information';
        barcodeResult2 = 'Failed to load barcode information';
        check(barcodeResult, barcodeResult2);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.13),
              Text(
                'Boycott',
                style: GoogleFonts.inter(
                  fontSize: screenSize.width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.0, 0.0), // Set the shadow offset
                      blurRadius: 200.0, // Set the blur radius
                      color: const Color.fromARGB(255, 0, 0, 0)
                          .withOpacity(1), // Set the shadow color
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.28),
                Container(
                  width: screenSize.width * 0.85,
                  height: screenSize.height * 0.11,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 239, 0, 107),
                      width: screenSize.width * 0.01,
                    ),
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.16),
                Expanded(
                  child: Transform.scale(
                    scale: screenSize.width * 0.00284,
                    child: Expanded(
                      child: Card(
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: screenSize.width * 0.43,
                                      left: screenSize.width * 0.43),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.008),
                                    child: Container(
                                      width: screenSize.width * 0.8,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                Button(
                                    onTap: () {
                                      scanBarcode();
                                    },
                                    text: 'Find',
                                    screenSize: screenSize),
                                Text(
                                  'Product:',
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.06,
                                      color: const Color.fromARGB(
                                          255, 239, 0, 107),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$barcodeResult',
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.05,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: Divider(
                                    thickness: 2.0,
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                Text(
                                  'Manufacturer:',
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.06,
                                      color: const Color.fromARGB(
                                          255, 239, 0, 107),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$barcodeResult2',
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.05,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 30, left: 30),
                                  child: Divider(
                                    thickness: 2.0,
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                Text(
                                  'Status:',
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.06,
                                      color: const Color.fromARGB(
                                          255, 239, 0, 107),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  status,
                                  style: GoogleFonts.inter(
                                      fontSize: screenSize.width * 0.05,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: screenSize.height * 0.026)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
