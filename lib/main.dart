import 'package:flutter/material.dart';
import 'package:zadulmuslihin/screens/lessons_screen.dart';
import 'screens/home_screen.dart';
import 'screens/daily_worship_screen.dart';
import 'screens/islamic_info_screen.dart';
import 'screens/daily_tasks_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/thoughts_screen.dart';
import 'screens/settings_screen.dart';
import 'data/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  runApp(const ZadulMuslihinApp());
}

class ZadulMuslihinApp extends StatelessWidget {
  const ZadulMuslihinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'زاد المصلحين',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const DailyWorshipScreen(),
    const IslamicInfoScreen(),
    const DailyTasksScreen(),
    const QuranScreen(),
    const ThoughtsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('زاد المصلحين'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'زاد المصلحين',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'تطبيق إسلامي شامل',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الصفحة الرئيسية'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('الدروس'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('العبادات'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('معلومات إسلامية'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('المهام اليومية'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('القرآن الكريم'),
              selected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('سجل الخواطر'),
              selected: _selectedIndex == 6,
              onTap: () => _onItemTapped(6),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              selected: _selectedIndex == 7,
              onTap: () => _onItemTapped(7),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }
}



/*

[


    "https://youtube.com/playlist?list%3DPLKd_OPEHWrqiEmbm9fhOMw8cJtByfvvj8%26si%3DneRRG-VPj5MvNwXo&sa=D&source=editors&ust=1749227186666692&usg=AOvVaw3Ppo8jE6VQ6L08xBtn5-3P",
    "https://youtube.com/playlist?list%3DPL7ZS5BFtiPLI6sqX1W9HabZ3Kj5A0zz3R%26si%3DS_54V0okSPl59qfB&sa=D&source=editors&ust=1749227186665379&usg=AOvVaw0ltc_vODEcH7vUzKuLHaGv",
    "https://youtu.be/PYf-Jwx179o?si%3D_kPlDhmfrGTxce5C&sa=D&source=editors&ust=1749227186662942&usg=AOvVaw21iwEM2QovenvcshVCuqJZ",
    "https://youtu.be/-LjJhu67ne8?si%3DaL27CFwqHjkLNySc&sa=D&source=editors&ust=1749227186663053&usg=AOvVaw2Bcy6fQTlyZLAlDu6Me7hA",
    "https://youtu.be/m_Bo1fKDus4?si%3Dq_NvTRgwDSqBEYA5&sa=D&source=editors&ust=1749227186663106&usg=AOvVaw3J54lFdCaIBnt8A1IKVymi",
    "https://youtu.be/iPd3gCquQI4?si%3DYUzVgjR4bOingBLm&sa=D&source=editors&ust=1749227186663157&usg=AOvVaw2eTclZJ5fXc3Jc69cmE2TC",
    "https://youtu.be/SzoUA7Erq-I?si%3DNvMM70ywwf5Tlv8G&sa=D&source=editors&ust=1749227186663206&usg=AOvVaw0Z3hxmO5l10cf-CN6WK76i",
    "https://youtu.be/2fTvpQkDSyU?si%3DAlmq4YvIBrGVsu5y&sa=D&source=editors&ust=1749227186663258&usg=AOvVaw3_Np3TYxaO2pgaHLq8vSRM",
    "https://youtu.be/CX5J64NSr2U?si%3DTe6yt5IWk-sLseDk&sa=D&source=editors&ust=1749227186663314&usg=AOvVaw1q6Li7MZCLyk0U4AlNnTpb",
    "https://youtube.com/playlist?list%3DPLMPqxr1nu2ZdTxO3jSorQ8G3pL1ZIFxba%26si%3Dq9_FZ0WvLem0_Rqy&sa=D&source=editors&ust=1749227186659421&usg=AOvVaw2IjvverHkVlr_M0PtYZWGy",
    "https://youtu.be/o6_8XeXrwH8?si%3DoMvU6ON2Nl5iNK3W&sa=D&source=editors&ust=1749227186654720&usg=AOvVaw10jDxHu5KghCDC9TsWC0L3",
    "https://youtu.be/RUJiOPmD8o4?si%3DD01en2TNCG6tZiUO&sa=D&source=editors&ust=1749227186655495&usg=AOvVaw2V6EW1FRKJQd2yQcOM4CdJ",
    "https://youtube.com/playlist?list%3DPLukAHj56HNKZjq0eUdO_zr7a5zFbyZyuf%26si%3DWp0zm9PjPHYpNaMy&sa=D&source=editors&ust=1749227186542537&usg=AOvVaw0bTs_7Z_ZLQ00AnEIZSUaV",
    "https://youtube.com/playlist?list%3DPLRHyLucIVdrMvFCQWaIBxIhZPSGY5fmTI%26si%3DPrNeeYe9K-3lH2GQ&sa=D&source=editors&ust=1749227186656639&usg=AOvVaw0fni8QWFM6hda9LjR9j-E7",
    "https://youtube.com/playlist?list%3DPL6iF9dYZOcHvQE1rrJs224Pd1tDTu-bHH%26si%3DtNiSauWwuIsRMk4k&sa=D&source=editors&ust=1749227186658684&usg=AOvVaw17gBiUGFME8ao1htxXLE5a",
    "https://youtube.com/playlist?list%3DPLp3nBfwwVsyKPT8EDL-QUPlxU3WRdzI59%26si%3DBfvwhvyYojEj7E0z&sa=D&source=editors&ust=1749227186657371&usg=AOvVaw3ajIsVdLl0wmGdJWyCEWPe",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3DK7sXaoIiML0mQB5l&sa=D&source=editors&ust=1749227186654262&usg=AOvVaw2zA_M07N1inYwCxg8OiTYc",
    "https://youtube.com/playlist?list%3DPLSVWH21xe617GaGYEFmEYY3XGLYBiR-ZO%26si%3Ddtxnالمقرر العلميb_covnozvL&sa=D&source=editors&ust=1749227186652983&usg=AOvVaw08Je3y-CZWwCiWfgCd6KcZ",
    "https://youtube.com/playlist?list%3DPLVn5UigDlJB_zD26j-SZ9eRIfOHWI6OoL%26si%3DB7HGdY2lYpvEmwQy&sa=D&source=editors&ust=1749227186651528&usg=AOvVaw2fM30W7MJiLSGLkfzMgNYq",
    "https://youtube.com/playlist?list%3DPLH5y7ZzK7PCBpQFK-YMhjBt4gkFOH3Sg1%26si%3Dd7dl2ptSbyY2Rfb5&sa=D&source=editors&ust=1749227186632921&usg=AOvVaw04VXh3otedR5giZZlO6LEb",
    "https://youtu.be/rldfiEfPBDg?si%3D7F65Kj9m071IL5r1&sa=D&source=editors&ust=1749227186535717&usg=AOvVaw1x3ps-DAkD9Oev86beFiAi",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3DK7sXaoIiML0mQB5l&sa=D&source=editors&ust=1749227186630434&usg=AOvVaw1_vw_TyERZejufU6xeCfcG",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186631582&usg=AOvVaw2tLgqCeKQroslthVnA1_yD",
    "https://youtube.com/playlist?list%3DPLD-tRLG3gV22Fi5-zHofrzgKSLPqImWLG%26si%3DhHl00uDMe6Em24Hn&sa=D&source=editors&ust=1749227186650096&usg=AOvVaw2_UJfDXK8lYPwZ3tH9PWzA",
    "https://youtu.be/xyqb_hl8HAk?si%3DLw9WF6SATgjp8GPK&sa=D&source=editors&ust=1749227186650186&usg=AOvVaw3-MzscXu0sWZ5_yK4JCjVY",
    "https://youtube.com/playlist?list%3DPLsRtYZTCYnEdUMt_aelwwZ79D4aFcg86_%26si%3D5CAa2yzWca9T-AnF&sa=D&source=editors&ust=1749227186648348&usg=AOvVaw37z5TmWhFCtrm9qJA8X1aJ",
    "https://youtu.be/pJ0auP7dbcY?si%3DLNZ_u5So-M5e3DWk&sa=D&source=editors&ust=1749227186648475&usg=AOvVaw3P2a2ep7yoq1yL-x6ZELij",
    "https://youtube.com/playlist?list%3DPLSSxr3Rf2_X1QNGSYhHRVM4xW9_CWQe4B%26si%3D89gliNE8Ax9CUNu2&sa=D&source=editors&ust=1749227186646404&usg=AOvVaw0PUO7gWZjdKGdTD643aXQQ",
    "https://youtu.be/200SDiX61a0?si%3Dk5iMeFgdmWJ1RSs-&sa=D&source=editors&ust=1749227186643954&usg=AOvVaw3Y-y-ZeRDDQaL-mLlfq0SI",
    "https://youtu.be/q6j_tNV79IA?si%3Dqg60YFwXTGr_XANZ&sa=D&source=editors&ust=1749227186644038&usg=AOvVaw1hdK9HLfqn6k_yu7hdJmJJ",
    "https://youtube.com/playlist?list%3DPL-ZWNyL2NZVDrWbeOHinAMdgskI2uNcO3%26si%3DW5fUoCR01qjsVeMn&sa=D&source=editors&ust=1749227186645166&usg=AOvVaw3RqGOyVHxG7VBYG_YX3Ks6",
    "https://www.youtube.com/watch?v%3DycAivJHSDDk%26list%3DPLAS4BS2Mc3oAn3lglLlMUpvz82FRPMn9t&sa=D&source=editors&ust=1749227186539873&usg=AOvVaw1366IjdDgYJIPmnSMcp9kK",
    "https://youtube.com/playlist?list%3DPLgy4vJv06sgbmtgEbusVl9LekXGg1DYsV%26si%3DRusbIDothqgBcbAW&sa=D&source=editors&ust=1749227186538501&usg=AOvVaw1WWuigitV3rYMiVJ6qgdhe",
    "https://youtube.com/playlist?list%3DPLclWMrvMpraCYaYmMDWE3jFsaP5so689g%26si%3D19itrxhFunPecIzX&sa=D&source=editors&ust=1749227186642696&usg=AOvVaw0OFpIB3pKEWSSBQp2i-wCp",
    "https://youtu.be/ocHJg55aRSs?si%3DAdd8Ki4Jlo-f1MgL&sa=D&source=editors&ust=1749227186642798&usg=AOvVaw2QVVatROkRxBhHToCHwiaZ",
    "https://youtu.be/NB4j8yBG5qg?si%3DBlQRT_4TVqXGhajm&sa=D&source=editors&ust=1749227186640553&usg=AOvVaw2IFc3VeAfRlwwgQigoJaEn",
    "https://youtu.be/Y9aIPcWQZ7s?si%3D6HHY7pBmDdgSsJ9B&sa=D&source=editors&ust=1749227186640648&usg=AOvVaw18sgkE2mYTJbygDoKid2Py",
    "https://youtube.com/playlist?list%3DPLnpknmCXt_N5X7DKYKcYk5EkyW0-wmyJ0%26si%3DK0BzJj8wCuyXWrKb&sa=D&source=editors&ust=1749227186638942&usg=AOvVaw3g9ZlNhwQooNepzW0wk4MH",
    "https://youtu.be/-OCT6kQltaA?si%3DDnGOI5erIQIZfuib&sa=D&source=editors&ust=1749227186637701&usg=AOvVaw02AePyBDkEz1gDHn0L-Zvf",
    "https://youtube.com/playlist?list%3DPLnpknmCXt_N5X0DDH4sEaD8iIGLSalWbW%26si%3DQzd6PEdJnZJwhNkz&sa=D&source=editors&ust=1749227186635967&usg=AOvVaw0SasYZnGyH5kFfxucZaxIw",
    "https://youtube.com/playlist?list%3DPLZmiPrHYOIsT0PkIptFKZNq9YG6w9bnYW%26si%3D57uDsHQb2dJaTJRn&sa=D&source=editors&ust=1749227186634750&usg=AOvVaw1SAlADYV-9AbxDtdvzdNY1",
    "https://youtu.be/tml4dZ2j7lw?si%3DochhC6XKy03m2eFm&sa=D&source=editors&ust=1749227186633661&usg=AOvVaw0L0En5bL56qWm54PcDOJM1",
    "https://youtu.be/rot01vW75LQ?si%3D-qrmmYvkQ1IcX2io&sa=D&source=editors&ust=1749227186611586&usg=AOvVaw3VH37yTedUzygcSC_RVUu7",
    "https://youtube.com/playlist?list%3DPL1sMjbA6QDbONTHYQbWUZCt4eShWIEmBI%26si%3DfGNjUphEC3uHExgu&sa=D&source=editors&ust=1749227186610835&usg=AOvVaw1JdLQdrcc93RFlVRQKjJHk",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3DK7sXaoIiML0mQB5l&sa=D&source=editors&ust=1749227186609578&usg=AOvVaw0COkNqm77empDK5ytfh_b_",
    "https://youtu.be/tpTae0waY60?si%3D85V5trTQar_7TTCK&sa=D&source=editors&ust=1749227186629058&usg=AOvVaw16KQP_653fdN6maHN_UsdX",
    "https://youtu.be/4HOJUamxu2Q?si%3D3Kfe_yXGBjZ8ZpSd&sa=D&source=editors&ust=1749227186629137&usg=AOvVaw2AxXCX1x7DdEWxJR4d54n3",
    "https://youtube.com/playlist?list%3DPLuUMLXxxQ8fh8hN7M5QPAiJkvgyuYIJ7v%26si%3DC8ZiR_zWbyy2oJR8&sa=D&source=editors&ust=1749227186627847&usg=AOvVaw0zotIudu1oxJ56XAsC6TqL",
    "https://youtube.com/playlist?list%3DPLnpknmCXt_N7kyQELnum6u6EGEfDw2-p2%26si%3D4sgFeZN5k8zsCEYf&sa=D&source=editors&ust=1749227186625881&usg=AOvVaw3yoGq-tJIa2A5PV3-AUmZE",
    "https://youtube.com/playlist?list%3DPLWK-UN87Vy36IxNX0k2jDOYnTlD4eWlDm%26si%3DRepdyv99oMywfwBY&sa=D&source=editors&ust=1749227186624599&usg=AOvVaw270QJ6IfoenZxHuzzJ8n7t",
    "https://youtube.com/playlist?list%3DPLZmiPrHYOIsR2NrqHDrgiyml043rtRLwS%26si%3DEYqaXrvmISiRU9_S&sa=D&source=editors&ust=1749227186622211&usg=AOvVaw3sAgaNswz1nscmaeo-sIHT",
    "https://youtu.be/-OCT6kQltaA?si%3DDnGOI5erIQIZfuib&sa=D&source=editors&ust=1749227186623346&usg=AOvVaw0rO5uBTkNT9-UFygJBYom8",
    "https://youtu.be/ee7o0iK26C0?si%3DvKHoM1GchsyQsbA9&sa=D&source=editors&ust=1749227186620965&usg=AOvVaw0iBbbVUB8SCRUvdaXTJaFP",
    "https://youtu.be/OpTiiX168bQ?si%3D70o8EiDCwWX1rBE6&sa=D&source=editors&ust=1749227186620209&usg=AOvVaw18YDgd1G0CoV1AeEIp_a4w",
    "https://youtube.com/playlist?list%3DPLF8wQ8_AW0LzBVP688EGsRXwodbWJbuJm%26si%3DbwK_KQ88187BhIcT&sa=D&source=editors&ust=1749227186619224&usg=AOvVaw0R9C91bfaLP1W4gJN7hdVj",
    "https://youtube.com/playlist?list%3DPL54tsaxKeZjP3ZXGyP3HpgPY3b4SqNrI_%26si%3DxVaiF61l1zvLT7Z_&sa=D&source=editors&ust=1749227186619367&usg=AOvVaw1SJrhciQBEPRw0n22S34qm",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3Dhzu-X6EdNEevcl-R&sa=D&source=editors&ust=1749227186619444&usg=AOvVaw1iWN3w7bDKpWsNL21sn6xM",
    "https://youtube.com/playlist?list%3DPLWK-UN87Vy37HKennPyIny_mlVTsmOhIV%26si%3DA5OrytxxCbtL7cgd&sa=D&source=editors&ust=1749227186615338&usg=AOvVaw1jbU-beAeUVwczPMwB0VD-",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186613994&usg=AOvVaw18ylCIZkgWF2YOu5LKpB6-",
    "https://youtube.com/playlist?list%3DPLclWMrvMpraAl6dCi-3fvh4dv1wFyKfqJ%26si%3D8iAIpS4dIrUBL3FQ&sa=D&source=editors&ust=1749227186612857&usg=AOvVaw16BiEdBPDl8lbJiLabcVkl",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186579680&usg=AOvVaw1f3T4PF8iFnUdttV9Lvsr9",
    "https://youtu.be/SW44kJFS8aE?si%3D4h3XoFexd6tLFqBL&sa=D&source=editors&ust=1749227186578585&usg=AOvVaw30JrS_Opm5JHLKWLfKyxvq",
    "https://youtu.be/gAqPDITXaNE?si%3Dxb__8YMYNAmShKLi&sa=D&source=editors&ust=1749227186577840&usg=AOvVaw2doxPj3E2tiY9Qf1rgqTK9",
    "https://youtube.com/playlist?list%3DPL9hkk6GeaGBd2-kkVhkj9EwQjxfFLgالمقرر المهاريI%26si%3DVoCe6qtNBNGiNBAr&sa=D&source=editors&ust=1749227186608147&usg=AOvVaw0SyAkeeaWCynzZfkxyzYW3",
    "https://youtube.com/playlist?list%3DPLWPQhUZOmeNtawrFccrJdFJTY8V38crdo%26si%3Dv_Azcg4LxLjkl3aw&sa=D&source=editors&ust=1749227186608283&usg=AOvVaw3CCM2e-j32rCHF2HkqR34W",
    "https://youtube.com/playlist?list%3DPLoslTfCHb8N-fI69sNcTAVTh9JDrspjo2%26si%3DCWSHkJxhaZmv9zn_&sa=D&source=editors&ust=1749227186605525&usg=AOvVaw1979uAJCNeCfrtqrDOGRBg",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186604139&usg=AOvVaw2HHDZdCoeFtTiNj5e8sKN6",
    "https://youtube.com/playlist?list%3DPLLwu_B1tgsvM0y3NgnzzPZLiOq8oEp2Mi%26si%3DBZYA_EW2Z8l6DxfC&sa=D&source=editors&ust=1749227186602741&usg=AOvVaw281i0GO2WrHytddMLdKRnf",
    "https://youtube.com/playlist?list%3DPLLwu_B1tgsvMnxoJcqw1e-5ljawRqIRYO%26si%3D9H306uEMRuhb-pq7&sa=D&source=editors&ust=1749227186602877&usg=AOvVaw31i2tBhsNAsUpoaYWmFch6",
    "https://youtube.com/playlist?list%3DPLf2brloBt8YeXhYCPcTQiy1hxOuT_bDVu%26si%3Dg4B5KH_ALirEAo-j&sa=D&source=editors&ust=1749227186602948&usg=AOvVaw1BtU1qYIzVBCVulhoAFT08",
    "https://youtube.com/playlist?list%3DPLDN8vU_ZehsWTQbtkaFemwbfT-igr8cHa%26si%3DKdsJiTlcB-XaReuM&sa=D&source=editors&ust=1749227186599246&usg=AOvVaw3nycKv4n4pbKAoHMNlXw4u",
    "https://youtu.be/RXXRIkpoylk?si%3DS_oالمقرر المهاريR5DAbhEAm1_&sa=D&source=editors&ust=1749227186597262&usg=AOvVaw3i-NY2fvQ0eqwyFtbq3Bpa",
    "https://youtu.be/eNc5smeYQPw?si%3DWfz0ge3Alx_ZxB-B&sa=D&source=editors&ust=1749227186597402&usg=AOvVaw2B5q_B0YlVKfKxvaIgA70P",
    "https://youtu.be/vrfG57MVxxo?si%3DKtm9kVEFaXB7eokA&sa=D&source=editors&ust=1749227186597466&usg=AOvVaw10R17eoz5Tx9hsbyfsBsr9",
    "https://youtu.be/bwC3WT3yTnE?si%3DEW5KVa9PL2SvCK8Q&sa=D&source=editors&ust=1749227186597517&usg=AOvVaw3pOasp6HU657v0VU-eP2rJ",
    "https://islamonline.net/archive/%25D9%2581%25D8%25B6%25D9%2584-%25D8%25A7%25D9%2584%25D8%25B9%25D8%25B4%25D8%25B1-%25D9%2585%25D9%2586-%25D8%25B0%25D9%258A-%25D8%25A7%25D9%2584%25D8%25AD%25D8%25AC%25D8%25A9/&sa=D&source=editors&ust=1749227186597595&usg=AOvVaw3t9OxiaMKf4c4gAvRhQQVV",
    "https://youtu.be/gZv5hFW3OF8?si%3DXGvL9nT9DX5eFmD4&sa=D&source=editors&ust=1749227186593142&usg=AOvVaw2r5QFcSAc2gfAPwbXpnq5N",
    "https://youtu.be/p_9AXliS6A4?si%3D_9cH7OQg2Wkw6u8E&sa=D&source=editors&ust=1749227186588552&usg=AOvVaw0d-lk3RyNt70LWqoSR3-Xu",
    "https://youtube.com/playlist?list%3DPLO-j8HIhDfQ28Tvz1vKxLlT5IEszjyYra%26si%3D2R5jRNWUeSNYku9s&sa=D&source=editors&ust=1749227186589922&usg=AOvVaw0MUVVZqRPTD9DYpL_Q04ig",
    "https://youtube.com/playlist?list%3DPLMPqxr1nu2Zc_vfl_Kinxm2sJwUMjRucs%26si%3DCym2mKQj2enzD8M9&sa=D&source=editors&ust=1749227186587583&usg=AOvVaw3UP_prchTSEe-iSRCRIFW9",
    "https://youtube.com/playlist?list%3DPLlX1sKIV4qu9jva6wfEflLYBqpJb4RRXL%26si%3DUsqTucyVzNfU_415&sa=D&source=editors&ust=1749227186533340&usg=AOvVaw0xXkdOfwRa_nRZLskP0mj7",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186558421&usg=AOvVaw2MnWER1djmPSeeSuRxdbo0",
    "https://youtube.com/playlist?list%3DPLsuYdg42VNlHitO65oz-wJ442Mo4qgfGl%26si%3DERgkGYwA9BoIEYy1&sa=D&source=editors&ust=1749227186557280&usg=AOvVaw3VqGnKnoGvZyrrgbqKi0i0",
    "https://youtube.com/playlist?list%3DPLbDRORmj0gydTo5IUj0QhhEqjTEJBAR_L%26si%3D-ZGHDDY-j_fRmrZ0&sa=D&source=editors&ust=1749227186555926&usg=AOvVaw3jckT9P00TdCoT3lnJcWwB",
    "https://youtu.be/GLbO1xGdU6M?si%3DIhixWoالمقرر المهاريfIrkunH5&sa=D&source=editors&ust=1749227186576787&usg=AOvVaw3EWGcHBgPvYmbUbmNqbLjg",
    "https://youtube.com/playlist?list%3DPLO_TuKrhMqkUU0N9_hJ5-79Tcc0c3QnCu%26si%3DVfp0w8Kvfz7srv8y&sa=D&source=editors&ust=1749227186576051&usg=AOvVaw2KFkqmnguc-TlQ6f_rvd9c",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3DK7sXaoIiML0mQB5l&sa=D&source=editors&ust=1749227186574788&usg=AOvVaw2TbnyPzc80RPWuYBWrfiU9",
    "https://youtube.com/playlist?list%3DPLclWMrvMpraCYaYmMDWE3jFsaP5so689g%26si%3D19itrxhFunPecIzX&sa=D&source=editors&ust=1749227186573481&usg=AOvVaw1zYzXxXl4Ye0iG6OrDX0A6",
    "https://youtube.com/playlist?list%3DPL7cjLZ8WuCQK6KR3eEdwTt7AXadFCdY7A%26si%3DK7sXaoIiML0mQB5l&sa=D&source=editors&ust=1749227186570826&usg=AOvVaw0LOSSqtgm3VJsX8rywoS7c",
    "https://youtube.com/playlist?list%3DPLO-j8HIhDfQ28Tvz1vKxLlT5IEszjyYra%26si%3D2R5jRNWUeSNYku9s&sa=D&source=editors&ust=1749227186572185&usg=AOvVaw3qHxmExzrpof3-uXRkKhbz",
    "https://youtu.be/SxisUEX4zWI?si%3DMFT4yMQSL3aygrzg&sa=D&source=editors&ust=1749227186569576&usg=AOvVaw0wexaIhSANQRWkhxaX4o70",
    "https://youtube.com/playlist?list%3DPLZmiPrHYOIsT9cC68G_p2sumuZTyBCAQQ%26si%3DEالمقرر العلميVohboPIqhuJEj&sa=D&source=editors&ust=1749227186568707&usg=AOvVaw0ETiJZzWc2AvXx-_oJw9fD",
    "https://youtube.com/playlist?list%3DPLWK-UN87Vy36IxNX0k2jDOYnTlD4eWlDm%26si%3DRepdyv99oMywfwBY&sa=D&source=editors&ust=1749227186567445&usg=AOvVaw3Pgr5YqQAOELlpewsMXb4n",
    "https://youtu.be/ODGyyljTvZY?si%3DHxZ0zCngARyaOCdb&sa=D&source=editors&ust=1749227186565761&usg=AOvVaw1fMDHHw7SME9vqk7i1u5uW",
    "https://youtu.be/MkstRC-GA-E?si%3DQYTQbvOZVn2ggPqE&sa=D&source=editors&ust=1749227186565878&usg=AOvVaw1RiWJ9BvsLH7J2W1qd4_Wn",
    "https://youtu.be/r5S9AypOA78?si%3DfmTlvsVtgDWgJqfX&sa=D&source=editors&ust=1749227186565959&usg=AOvVaw1u4hGI7aWvLBifLf3V81wi",
    "https://youtu.be/qGTWV7wZgcI?si%3D8eZv4oICtqH3KhSV&sa=D&source=editors&ust=1749227186566020&usg=AOvVaw0Cavip5CMp6iXxfNRqVNr5",
    "https://youtu.be/msIVKr8PtC0?si%3D0ZVMWhtg0-Vh5XZ9&sa=D&source=editors&ust=1749227186566070&usg=AOvVaw1hSodDlfwwPCnpJl7O0k5P",
    "https://youtu.be/2j8kTeFKqJ4?si%3DIHOE3lbatwtZWHdQ&sa=D&source=editors&ust=1749227186566121&usg=AOvVaw0HdVCzcyoW6hgu5hd8zqFA",
    "https://youtube.com/playlist?list%3DPLclWMrvMpraAl6dCi-3fvh4dv1wFyKfqJ%26si%3D8iAIpS4dIrUBL3FQ&sa=D&source=editors&ust=1749227186562098&usg=AOvVaw0CMaemKIzXHKhFMOgPq_Az",
    "https://youtube.com/playlist?list%3DPL54tsaxKeZjP3ZXGyP3HpgPY3b4SqNrI_%26si%3DxVaiF61l1zvLT7Z_&sa=D&source=editors&ust=1749227186560772&usg=AOvVaw0ThXOluAegI_kGArHoj2bS",
    "https://youtu.be/WSjjnYJX180?si%3D7jucUKU38jTBmRhE&sa=D&source=editors&ust=1749227186546778&usg=AOvVaw1Wyg5HQYp9izgVRjd_FUbm",
    "https://youtu.be/J65ZEsHdqrs?si%3D1naO_0CciY-DDj5p&sa=D&source=editors&ust=1749227186559279&usg=AOvVaw1ROlM7raZz0B_VV5ea5CfH",
    "https://youtube.com/playlist?list%3DPLclWMrvMpraAl6dCi-3fvh4dv1wFyKfqJ%26si%3D8iAIpS4dIrUBL3FQ&sa=D&source=editors&ust=1749227186544730&usg=AOvVaw0eyRcmYEgglf5UkG_obY88",
    "https://youtube.com/playlist?list%3DPL-ZWNyL2NZVDrWbeOHinAMdgskI2uNcO3%26si%3DW5fUoCR01qjsVeMn&sa=D&source=editors&ust=1749227186545930&usg=AOvVaw3kywNa1CCbV2R7gWbuWA1N",
    "https://youtube.com/playlist?list%3DPLZmiPrHYOIsT0PkIptFKZNq9YG6w9bnYW%26si%3D57uDsHQb2dJaTJRn&sa=D&source=editors&ust=1749227186554771&usg=AOvVaw2uEn1N8xJZWokWY4yYh_ri",
    "https://youtu.be/XDGzkTJ9H70?si%3Dq83-KHUdES-DT5Fe&sa=D&source=editors&ust=1749227186553572&usg=AOvVaw0QNplN58CgreTrN4PgF8DB",
    "https://youtu.be/D3gunb0UuVY?si%3DqaDNPLYGOah_Sqpa&sa=D&source=editors&ust=1749227186553662&usg=AOvVaw083i22zW1hnQNM7qzyOnFo",
    "https://youtube.com/playlist?list%3DPL-ZWNyL2NZVDrWbeOHinAMdgskI2uNcO3%26si%3DW5fUoCR01qjsVeMn&sa=D&source=editors&ust=1749227186551969&usg=AOvVaw0HGYQq2TkHS8Z-wh8RX034",
    "https://youtube.com/playlist?list%3DPLgy4vJv06sgbmtgEbusVl9LekXGg1DYsV%26si%3DRusbIDothqgBcbAW&sa=D&source=editors&ust=1749227186531465&usg=AOvVaw3V3fMwTx_bd2yojQamlPK9",
    "https://youtube.com/playlist?list%3DPLZmiPrHYOIsQMpwdg-LEUnb7c1LDxkQv5%26si%3DoaWsN-7LxcCgMSPS&sa=D&source=editors&ust=1749227186550632&usg=AOvVaw2cHO2Bjz-cHT4lXRJcFRCn",
    "https://youtu.be/jBBb4mSMOeI?si%3DqsDjhrce36Jm3VAM&sa=D&source=editors&ust=1749227186549337&usg=AOvVaw1BTAKJiHi5p59cA5jSGvQ1",
    "https://youtu.be/OJbl16IhNFg?si%3D_u1VYxuMn5qd_Coe&sa=D&source=editors&ust=1749227186549443&usg=AOvVaw1tGA0YIxao_Q-CM6lq8Qup",
    "https://youtube.com/playlist?list%3DPLMPqxr1nu2Zc_vfl_Kinxm2sJwUMjRucs%26si%3DCym2mKQj2enzD8M9&sa=D&source=editors&ust=1749227186548068&usg=AOvVaw3w8tsxNKZN8A7D0DbfNE-L",
    "https://support.google.com/docs/answer/65129",
    "https://youtu.be/rldfiEfPBDg?si=7F65Kj9m071IL5r1",
]*/